require 'rails_helper'

RSpec.describe Micropost, type: :model do
  let(:user) { create(:user) }
  let(:micropost) { user.microposts.build(content: 'Lorem ipsum') }

  it 'should be valid' do
    expect(micropost).to be_valid
  end

  it 'user id should be present' do
    micropost.user_id = nil
    expect(micropost).not_to be_valid
  end

  it 'content should be present' do
    micropost.content = ''
    expect(micropost).not_to be_valid
  end

  it 'content should be at most 140 characters' do
    micropost.content = 'a' * 141
    expect(micropost).not_to be_valid
  end

  it 'order should be most recent first' do
    post1 = create(:micropost, user: user, content: 'content 1')
    post2 = create(:micropost, user: user, content: 'content 2')
    expect(user.microposts.resent).to eq([post2, post1])
  end
end
