require 'rails_helper'

RSpec.describe 'Users', type: :request do

  describe 'GET /signup' do
    it 'returns http success' do
      get signup_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /users' do
    it 'should redirect index when not logged in' do
      get users_path
      expect(response).to redirect_to(login_path)
    end
  end

  describe 'PUT /users/:user_id' do
    it 'should redirect update when not logged in' do
      user = create(:user, name: 'user')
      expect {
        patch user_path(user), params: {user: {name: 'renamed', email: user.email}}
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(login_path)
      }.to_not change(user, :name)
    end

    it 'should redirect update when logged in as wrong user' do
      user = create(:user, name: 'user')
      other_user = create(:user, name: 'other user')
      expect {
        login_as(other_user)
        patch user_path(user), params: {user: {name: 'renamed', email: user.email}}
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(root_path)
      }.to_not change(user, :name)
    end

    it 'should not allow the admin attribute to be edited via the web' do
      user = create(:user, name: 'user', admin: false)
      login_as(user)
      patch user_path(user), params: {user: {name: 'renamed', admin: true}}

      user.reload
      expect(user.name).to eq 'renamed'
      expect(user.admin).to be_falsey
    end
  end

  describe 'DELETE /users/:user_id' do
    it 'should redirect destroy when not logged in' do
      user = create(:user, name: 'user', admin: false)
      other_user = create(:user, name: 'other user', admin: false)
      expect {
        delete user_path(other_user)
        expect(response).to redirect_to(login_path)
      }.to_not change(User, :count)
    end

    it 'should redirect destroy when logged in as a non-admin' do
      user = create(:user, name: 'user', admin: false)
      other_user = create(:user, name: 'other user', admin: false)
      expect {
        login_as(user)
        delete user_path(other_user)
        expect(response).to redirect_to(root_path)
      }.to_not change(User, :count)
    end
  end

  describe 'GET /users/:user_id/following' do
    it 'should redirect following when not logged in' do
      user = create(:user)
      get following_user_path(user)
      expect(response).to redirect_to(login_path)
    end
  end

  describe 'GET /users/:user_id/followers' do
    it 'should redirect following when not logged in' do
      user = create(:user)
      get followers_user_path(user)
      expect(response).to redirect_to(login_path)
    end
  end
end
