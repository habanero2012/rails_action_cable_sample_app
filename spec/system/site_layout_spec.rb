require 'rails_helper'

RSpec.describe 'layout test', test: :system do
  it 'layout links' do
    visit root_path

    expect(page).to have_link('Home', href: home_path)
    expect(page).to have_link('Help', href: help_path)
    expect(page).to have_link('About', href: about_path)
    expect(page).to have_link('Contact', href: contact_path)
  end
end
