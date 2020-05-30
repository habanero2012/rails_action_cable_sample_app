require 'rails_helper'

describe 'user edit test', test: :system do
  let(:user) { create(:user, name: 'user') }

  it 'unsuccessful edit' do
    login_as(user)
    visit edit_user_path(user)

    fill_in 'Name', with: ''
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'password'
    fill_in 'Confirmation', with: 'password'
    click_button 'Save changes'

    expect(page).to have_content "Name can't be blank"
  end

  it 'successful edit' do
    login_as(user)
    visit edit_user_path(user)

    fill_in 'Name', with: 'updated user'
    fill_in 'Email', with: user.email
    # fill_in 'Password', with: 'password'
    # fill_in 'Confirmation', with: 'password'
    click_button 'Save changes'

    expect(page).to have_content 'Profile updated'
    user.reload
    expect(user.name).to eq('updated user')
  end

  it 'should redirect edit when not logged in' do
    visit edit_user_path(user)

    expect(page).to have_current_path login_path
    expect(page).to have_content 'Please log in.'
  end

  it 'should redirect edit when logged in as wrong user' do
    other_user = create(:user, name: 'other_user')
    login_as(other_user)
    visit edit_user_path(user)

    expect(page).to have_current_path root_path
  end

  it 'friendly forwarding' do
    visit edit_user_path(user)
    login_as(user)

    expect(page).to have_current_path edit_user_path(user)
  end
end