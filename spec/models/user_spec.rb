require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  it 'has a valid factory' do
    expect(user).to be_valid
  end

  it 'name should be present' do
    user.name = ''
    expect(user).not_to be_valid
  end

  it 'email should be present' do
    user.email = ''
    expect(user).not_to be_valid
  end

  it 'name should not be too long' do
    user.name = 'a' * 51
    expect(user).not_to be_valid
  end

  it 'email should not be too long' do
    user.email = 'a' * 244 + '@example.com'
    expect(user).not_to be_valid
  end

  it 'email validation should accept valid addresses' do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      user.email = valid_address
      expect(user).to be_valid, "#{valid_address.inspect} should be valid"
    end
  end

  it 'email validation should reject invalid addresses' do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      user.email = invalid_address
      expect(user).not_to be_valid, "#{invalid_address.inspect} should be invalid"
    end
  end

  it 'email address should be unique' do
    email = 'user@example.com'
    create(:user, name: 'user1', email: email)
    duplicate_user = build(:user, name: 'user2', email: email.upcase)
    expect(duplicate_user).not_to be_valid
  end

  it 'email addresses should be saved as lower-case' do
    mixed_case_email = 'Foo@ExAMPle.CoM'
    user.email = mixed_case_email
    user.save
    expect(user.reload.email).to eq(mixed_case_email.downcase)
  end

  it 'password should be present (nonblank)' do
    user.password = user.password_confirmation = " " * 6
    expect(user).not_to be_valid
  end

  it 'password should have a minimum length' do
    user.password = user.password_confirmation = "a" * 5
    expect(user).not_to be_valid
  end

  it 'authenticated? should return false for a user with nil digest' do
    expect(user.authenticated?(:remember, '')).to be_falsey
  end

  it 'associated microposts should be destroyed' do
    user.save
    user.microposts.create!(content: 'Lorem ipsum')
    expect {
      user.destroy
    }.to change(Micropost, :count).by(-1)
  end

  it 'should follow and unfollow a user' do
    alice = create(:user)
    bob = create(:user)

    # フォロー前
    expect(alice.following?(bob)).to be(false)
    expect(bob.followers.include?(alice)).to be(false)

    alice.follow(bob)

    # フォロー中
    expect(alice.following?(bob)).to be(true)
    expect(bob.followers.include?(alice)).to be(true)

    alice.unfollow(bob)

    # フォロー解除
    expect(alice.following?(bob)).to be(false)
    expect(bob.followers.include?(alice)).to be(false)
  end

  it 'feed should have the right posts' do
    alice = create(:user)
    bob = create(:user)
    carol = create(:user)
    alice.follow(bob)

    # 投稿を作る
    3.times do |i|
      [alice, bob, carol].each { |u| u.microposts.create!(content: "#{u.name}'s content No. #{i + 1}") }
    end

    # フォローしているユーザーの投稿を確認
    bob.microposts.each do |post_following|
      expect(alice.feed.include?(post_following)).to be(true)
    end

    # 自分自身の投稿を確認
    alice.microposts.each do |post_self|
      expect(alice.feed.include?(post_self)).to be(true)
    end

    # フォローしていないユーザーの投稿を確認
    carol.microposts.each do |post_unfollowed|
      expect(alice.feed.include?(post_unfollowed)).to be(false)
    end
  end
end
