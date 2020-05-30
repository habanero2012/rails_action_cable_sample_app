require 'rails_helper'

RSpec.describe 'show following ', test: :system do
  let(:alice) { create(:user, name: 'alice') }
  let(:bob) { create(:user, name: 'bob') }
  let(:carol) { create(:user, name: 'carol') }

  before do
    alice.follow(bob)
    alice.follow(carol)
    carol.follow(alice)

    login_as(alice)
  end

  it "following page" do
    expect(alice.following.empty?).to be(false)

    visit following_user_path(alice)

    expect(page).to have_content alice.following.count.to_s
    expect(page).to have_link bob.name, href: user_path(bob)
    expect(page).to have_link carol.name, href: user_path(carol)
  end

  it "followers page" do
    expect(alice.followers.empty?).to be(false)

    visit followers_user_path(alice)

    expect(page).to have_content alice.followers.count.to_s
    expect(page).to have_link carol.name, href: user_path(carol)
  end
end
