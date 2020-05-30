class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :picture
  after_destroy :purge_picture

  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 140}
  validates :picture, blob: {content_type: %w[image/png image/jpg image/jpeg], size_range: 0..5.megabytes}

  scope :resent, -> { order(id: :desc) }

  private

  def purge_picture
    picture.purge if picture.attached?
  end
end
