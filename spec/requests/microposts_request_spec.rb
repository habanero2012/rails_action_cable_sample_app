require 'rails_helper'

RSpec.describe "Microposts", type: :request do
  describe 'POST /microposts' do
    it 'should redirect create when not logged in' do
      post microposts_path, params: {micropost: {content: 'Lorem ipsum'}}
      expect(response).to have_http_status(302)
      expect(response).to redirect_to(login_path)
    end
  end

  describe 'DELETE /microposts/:micropost_id' do
    it 'should redirect destroy when not logged in' do
      user = create(:user)
      micropost = create(:micropost, user: user)
      expect {
        delete micropost_path(micropost)
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(login_path)
      }.to change(Micropost, :count).by(0)
    end

    it 'should redirect destroy for wrong micropost' do
      user = create(:user)
      other_user = create(:user)
      other_users_micropost = create(:micropost, user: other_user)
      expect {
        delete micropost_path(other_users_micropost)
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(login_path)
      }.to change(Micropost, :count).by(0)
    end
  end
end
