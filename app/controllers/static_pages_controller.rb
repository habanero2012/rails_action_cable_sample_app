# frozen_string_literal: true
#
class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @micropost = current_user.microposts.build
      @feed_items = current_user.feed.page(params[:page]).per(10)
      @json_feed_items = ActiveModelSerializers::SerializableResource.new(@feed_items, each_serializer: MicropostSerializer).to_json
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
