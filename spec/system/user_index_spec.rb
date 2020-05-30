require 'rails_helper'

RSpec.describe 'user index' do
  let!(:user) { create(:user, name: 'michael') }

  it 'index including pagination' do
    login_as(user)
    visit users_path

    expect(page).to have_link('michael', href: user_path(user))
  end

  it 'index as admin delete links' do
    other_user = create(:user, name: 'other user', admin: true)
    login_as(other_user)
    visit users_path

    expect(page).to have_link('delete', href: user_path(user))
  end

  it 'index as non-admin' do
    other_user = create(:user, name: 'other user', admin: false)
    login_as(other_user)
    visit users_path

    expect(page).not_to have_link('delete', href: user_path(user))
  end
end