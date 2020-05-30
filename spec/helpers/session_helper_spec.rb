require 'rails_helper'

RSpec.describe SessionsHelper, test: :helper do
  describe '#current_user' do

    def is_logged_in?
      !session[:user_id].nil?
    end

    let(:user) { create(:user) }
    before do
      remember(user)
    end

    it 'current_user returns right user when session is nil' do
      expect(current_user.id).to eq(user.id)
      expect(is_logged_in?).to be_truthy
    end

    it 'current_user returns nil when remember digest is wrong' do
      user.update_attribute(:remember_digest, User.digest(User.new_token))
      expect(current_user).to be_nil
    end
  end
end
