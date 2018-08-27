class Micropost < ApplicationRecord
  before_validation :set_in_reply_to
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validates :in_reply_to, presence: false
  validate :check_picture_size, :reply_to_user

  def Micropost.including_replies(id)
    where(in_reply_to: [id, 0]).or(Micropost.where(user_id: id))
  end

  def set_in_reply_to
    # 返信のとき、@から始まる数字を読み取る
    if index = content.index("@")
      reply_id = []
      while is_i?(content[index+1])
        index += 1
        reply_id << content[index]
      end
      self.in_reply_to = reply_id.join.to_i
    else
      # @がなければ返信ではない
      self.in_reply_to = 0
    end
  end

  # sがintegerかどうか、nilのときにfalseを返す
  def is_i?(s)
    Integer(s) != nil rescue false
  end

  # in_reply_toに入るuser_idのチェック
  def reply_to_user
    return if self.in_reply_to == 0
    user = User.find_by(id: self.in_reply_to)
    unless user.present?
      errors.add(:error, "ユーザIDが存在しない")
    else
      if user_id == self.in_reply_to
        errors.add(:error, "自分に返信はできない")
      end
    end
  end

  private
    def check_picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "5MB以下しかアップできません")
      end
    end
end
