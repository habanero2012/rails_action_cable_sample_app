# frozen_string_literal: true

class Api::FeedsController < ApplicationController
  def index
    json_feed_items = []
    if logged_in?
      # feed_items = current_user.feed.page(params[:page]).per(10)
      feed_items = current_user.feed.limit(10)
      feed_items = feed_items.where('id < ?', params[:micropost_id]) if params[:micropost_id]
      json_feed_items = ActiveModelSerializers::SerializableResource.new(feed_items, each_serializer: MicropostSerializer).to_json
    end

    render json: json_feed_items
  end
end