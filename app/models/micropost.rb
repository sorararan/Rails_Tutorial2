class Micropost < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validate :check_picture_size

  private
    def check_picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "5MB以下しかアップできません")
      end
    end
end
