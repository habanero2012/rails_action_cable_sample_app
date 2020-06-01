require 'rails_helper'

RSpec.describe 'password resets', test: :system do
  after do
    ActionMailer::Base.deliveries.clear
  end

  let!(:user) { create(:user) }

  it 'メールアドレスが無効' do
    visit new_password_reset_path
    fill_in 'Email', with: ''
    click_button 'Reset password'
    expect(page).to have_content 'Email address not found'
  end

  it 'メールアドレスが有効' do
    visit new_password_reset_path

    expect {
      fill_in 'Email', with: user.email
      click_button 'Reset password'
      expect(page).to have_content 'Email sent with password reset instructions'
      expect(page).to have_current_path root_path
    }.to change(ActionMailer::Base.deliveries, :count).by(1)

    mail_body = ActionMailer::Base.deliveries.last.text_part.decoded
    reset_token = mail_body.match(%r{/password_resets/(.+?)/edit})[1]

    # メールアドレスが無効
    visit edit_password_reset_path(reset_token, email: '')
    expect(page).to have_current_path root_path

    # メールアドレスが有効で、トークンが無効
    visit edit_password_reset_path('wrong', email: user.email)
    expect(page).to have_current_path root_path

    # 無効なユーザー
    user.reload.toggle!(:activated)
    visit edit_password_reset_path(reset_token, email: user.email)
    expect(page).to have_current_path root_path
    user.toggle!(:activated)

    # メールアドレスもトークンも有効
    visit edit_password_reset_path(reset_token, email: user.email)
    expect(page).to have_content 'Reset password'

    # 無効なパスワードとパスワード確認
    fill_in 'Password', with: 'foobar'
    fill_in 'Confirmation', with: 'barquux'
    click_button 'Update password'
    expect(page).to have_content "Password confirmation doesn't match Password"

    # パスワードが空
    fill_in 'Password', with: ''
    fill_in 'Confirmation', with: ''
    click_button 'Update password'
    expect(page).to have_content "Password can't be blank"

    # 有効なパスワードとパスワード確認
    fill_in 'Password', with: 'password'
    fill_in 'Confirmation', with: 'password'
    click_button 'Update password'
    expect(page).to have_content 'Password has been reset.'
    expect(page).to have_current_path user_path(user)
  end

  it 'expired token' do
    visit new_password_reset_path

    expect {
      fill_in 'Email', with: user.email
      click_button 'Reset password'
      expect(page).to have_content 'Email sent with password reset instructions'
      expect(page).to have_current_path root_path
    }.to change(ActionMailer::Base.deliveries, :count).by(1)

    mail_body = ActionMailer::Base.deliveries.last.text_part.decoded
    reset_token = mail_body.match(%r{/password_resets/(.+?)/edit})[1]

    travel_to 121.minute.since do # 2時間後
      visit edit_password_reset_path(reset_token, email: user.email)
      expect(page).to have_content 'Password reset has expired.'
      expect(page).to have_current_path new_password_reset_path
    end
  end
end