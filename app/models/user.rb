class User < ApplicationRecord
  require "./app/validators/email_format_validator.rb"
  before_save { self.email = email.downcase }

  has_many :microposts
  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  attr_accessor :remember_token
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, emailformat: true, 
                    presence: true, length: {maximum: 255}, uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }

  # remember_digestに記憶
  def remember
    self.remember_token = Session.new_token
    update_attribute(:remember_digest, Session.create_digest(remember_token))
  end

  # 渡されたトークンがダイジェストと一致したらtrue
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # ユーザのログイン情報の破棄
  def forget
    update_attribute(:remember_digest, nil)
  end

  def feed
    following_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
    # フォローしてるユーザのマイクロポスト or 自分のポスト
    Micropost.where("user_id IN (#{following_ids}) OR user_id = :user_id", user_id: id)
  end

  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    following.include?(other_user)
  end
end
