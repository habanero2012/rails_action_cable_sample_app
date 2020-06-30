require 'rails_helper'

RSpec.describe 'user index', test: :system, js: true do
  let(:alice) { create(:user, name: 'alice') }
  let(:bob) { create(:user, name: 'bob') }

  before do
    alice.microposts.create!(content: "alice's post")
    bob.microposts.create!(content: "bob's post")
    alice.follow(bob)
  end

  it 'feed on Home page' do
    expect(alice.feed.include?(alice.microposts.first)).to be(true)
    expect(alice.feed.include?(bob.microposts.first)).to be(true)

    login_as(alice)
    visit root_path

    alice.feed.each do |micropost|
      expect(page).to have_content micropost.content
    end
  end
end