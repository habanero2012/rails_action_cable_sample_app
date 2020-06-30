# frozen_string_literal: true

class BroadcastService
  def initialize(micropost)
    @micropost = micropost
  end

  def call
    @micropost.user.followers.each { |follower| broadcast(follower) }
  end

  private

  def broadcast(to)
    TimelineChannel.broadcast_to(to, serialized_micropost)
  end

  def serialized_micropost
    @serialized_micropost ||= MicropostSerializer.new(@micropost).to_json
  end
end
