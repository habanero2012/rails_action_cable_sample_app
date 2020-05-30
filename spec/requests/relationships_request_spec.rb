require 'rails_helper'

RSpec.describe 'Relationships', type: :request do
  let(:alice) { create(:user, name: 'alice') }
  let(:bob) { create(:user, name: 'bob') }

  describe 'POST /relationships' do
    it 'create should require logged-in user' do
      expect {
        post relationships_path
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(login_path)
      }.to change(Relationship, :count).by(0)
    end

    it 'should follow a user the standard way' do
      login_as(alice)

      expect {
        post relationships_path, params: {followed_id: bob.id}
      }.to change(Relationship, :count).by(1)
    end

    it 'should follow a user with Ajax' do
      login_as(alice)

      expect {
        post relationships_path, params: {followed_id: bob.id}, xhr: true
      }.to change(Relationship, :count).by(1)
    end
  end

  describe 'DELETE /relationships' do
    it 'destroy should require logged-in user' do
      alice.follow(bob)
      relationship = alice.active_relationships.find_by(followed_id: bob.id)

      expect {
        delete relationship_path(relationship)
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(login_path)
      }.to change(Relationship, :count).by(0)
    end

    it 'should unfollow a user the standard way' do
      alice.follow(bob)
      relationship = alice.active_relationships.find_by(followed_id: bob.id)

      login_as(alice)
      expect {
        delete relationship_path(relationship)
      }.to change(Relationship, :count).by(-1)
    end

    it 'should unfollow a user with Ajax' do
      alice.follow(bob)
      relationship = alice.active_relationships.find_by(followed_id: bob.id)

      login_as(alice)
      expect {
        delete relationship_path(relationship), xhr: true
      }.to change(Relationship, :count).by(-1)
    end
  end
end
