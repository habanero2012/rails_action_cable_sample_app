module SystemMacros
  def login_as(user, password: 'password', remember_me: '1')
    visit login_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: password
    check 'Remember me on this computer' if remember_me == '1'
    click_button 'Log in'
  end
end

RSpec.configure do |config|
  config.include SystemMacros, type: :system
end