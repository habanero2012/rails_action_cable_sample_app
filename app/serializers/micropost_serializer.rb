# frozen_string_literal: true

class MicropostSerializer < ActiveModel::Serializer
  attributes :id, :content
  belongs_to :user, serializer: UserSerializer

  attribute(:created_at) { object.created_at.strftime('%Y-%m-%d %H:%M:%S') }
  attribute(:path) { Rails.application.routes.url_helpers.micropost_path(object) }

  attribute(:picture_path) do
    if object.picture.attached?
      Rails.application.routes.url_helpers.rails_representation_path(object.picture.variant(resize: '400x400').processed, only_path: true)
    else
      ''
    end
  end
end
