# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  include UsersHelper

  attributes :id, :name
  attribute(:user_path) { Rails.application.routes.url_helpers.user_path(object) }
  attribute(:gravatar_url) { gravatar_url(object, size: 80) }
end
