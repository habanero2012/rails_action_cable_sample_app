require 'rails_helper'

RSpec.describe 'user signup', test: :system do
  after do
    ActionMailer::Base.deliveries.clear
  end

  it 'invalid signup information' do
    visit signup_path

    expect {
      fill_in 'user[email]', with: 'user@example.com'
      fill_in 'user[password]', with: 'foo'
      fill_in 'user[password_confirmation]', with: 'bar'
      click_button 'Register'

      expect(page).to have_content "Name can't be blank"
      expect(page).to have_content "Password is too short (minimum is 6 characters)"
      expect(page).to have_content "Password confirmation doesn't match Password"
    }.to change(User, :count).by(0)
  end

  it 'valid signup information' do
    visit signup_path

    expect {
      fill_in 'user[name]', with: 'user'
      fill_in 'user[email]', with: 'user@example.com'
      fill_in 'user[password]', with: 'password'
      fill_in 'user[password_confirmation]', with: 'password'
      click_button 'Register'

      expect(page).to have_content 'Please check your email to activate your account.'
      expect(ActionMailer::Base.deliveries.count).to eq(1)
    }.to change(User, :count).by(1)


    mail_body = ActionMailer::Base.deliveries.last.text_part.decoded
    activation_token = mail_body.match(%r{/account_activations/(.+?)/edit})[1]

    # 有効化していない状態でのログイン
    user = User.last
    expect(user.activated?).to be(false)
    login_as(user)
    expect(page).to have_content 'Account not activated.'
    expect(page).to have_current_path root_path

    # 有効化が不正の場合
    visit edit_account_activation_path('invalid_token', email: user.email)
    expect(page).to have_content 'Invalid activation link'
    expect(page).to have_current_path root_path

    visit edit_account_activation_path(activation_token, email: 'wrong@example.com')
    expect(page).to have_content 'Invalid activation link'
    expect(page).to have_current_path root_path

    # 有効化トークンが正しい場合
    expect {
      visit edit_account_activation_path(activation_token, email: user.email)
      expect(page).to have_content 'Account activated!'
      expect(page).to have_current_path user_path(user)
    }.to change { user.reload.activated? }.from(false).to(true)
  end
end
