# frozen_string_literal: true

class BroadcastJob < ApplicationJob
  queue_as :default

  rescue_from ActiveJob::DeserializationError do |exception|
    # enqueue後、ジョブが実行される前にモデルが削除された場合起きるエラーをrescueする
  end

  def perform(micropost)
    BroadcastService.new(micropost).call
  end
end
