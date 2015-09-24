class User < ActiveRecord::Base
  after_save :load_into_soulmate
  before_destroy :remove_from_soulmate

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         stretches: 20

  has_many :statuses, dependent: :destroy
  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
  has_many :following, through: :active_relationships,  source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :conversations, foreign_key: :sender_id
  has_many :messages
  has_many :comments

  has_many :user_groups, dependent: :destroy
  has_many :groups, through: :user_groups

  has_one :admin_group, foreign_key: "admin_id"

  acts_as_voter

  def feed
    following_ids = "SELECT followed_id FROM relationships
                     WHERE  follower_id = :user_id"
    Status.status_not_group.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
  end

  # Follows a user.
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  # Unfollows a user.
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # Returns true if the current user is following the other user.
  def following?(other_user)
    following.include?(other_user)
  end

  def online?
    if current_sign_in_at.present?
      last_sign_out_at.present? ? current_sign_in_at > last_sign_out_at : true
    else
      false
    end
  end

  def self.search search
    if search
      User.where("name LIKE ?", "%#{search}%")
    else
      User.all
    end
  end

  private

  def load_into_soulmate
    loader = Soulmate::Loader.new("users")
    loader.add("term" => name, "id" => self.id, "data" => {
      "link" => Rails.application.routes.url_helpers.user_path(self)
      })
  end

  def remove_from_soulmate
    loader = Soulmate::Loader.new("users")
      loader.remove("id" => self.id)
  end
end
