require 'rails_helper'

RSpec.describe 'user profile', test: :system do
  let(:user) { create(:user) }

  before do
    5.times do |i|
      user.microposts.create!(content: "content No.#{i + 1}")
    end
  end

  it 'profile display' do
    visit user_path(user)

    expect(page).to have_content user.name
    expect(page).to have_content "Microposts#{user.microposts.count}"
    user.microposts.page(1).per(10).each do |micropost|
      expect(page).to have_content micropost.content
    end
  end
end