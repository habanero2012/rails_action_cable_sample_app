require 'rails_helper'

RSpec.describe 'user login', test: :system do
  let!(:user) { create(:user, name: 'user', email: 'user@example.com', password: 'password', password_confirmation: 'password') }

  it 'login with invalid information' do
    visit login_path

    fill_in 'Email', with: 'user@example.com'
    fill_in 'Password', with: 'foo'
    click_button 'Log in'

    expect(page).to have_content 'Invalid email/password combination'
  end

  it 'login with valid information followed by logout' do
    visit login_path

    fill_in 'Email', with: 'user@example.com'
    fill_in 'Password', with: 'password'
    click_button 'Log in'

    expect(page).to have_content 'Logged in'

    click_link 'Log out'

    expect(page).to have_content 'logged out'

    # 2番目のウィンドウでログアウトをクリックするユーザーをシミュレートする
    page.driver.submit :delete, logout_path, {}
    expect(page).to have_content 'logged out'
  end

  it 'login with remembering' do
    # クッキーを保存してログイン
    login_as(user)
    expect(page.driver.request.cookies['remember_token']).to be_truthy

    # ログアウト
    click_link 'Log out'

    # クッキーを削除してログイン
    login_as(user, remember_me: '0')
    expect(page.driver.request.cookies['remember_token']).to be_nil
  end
end
