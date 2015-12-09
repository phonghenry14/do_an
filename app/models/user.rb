class User < ActiveRecord::Base
  include CountActivities
  include Paperclip::Glue

  after_save :load_into_soulmate
  after_create :initialize_activity
  before_destroy :remove_from_soulmate

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :encryptable, stretches: 20

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
  has_many :tasks

  has_many :user_groups, dependent: :destroy
  has_many :groups, through: :user_groups
  has_many :user_events, dependent: :destroy
  has_many :events, through: :user_events

  has_one :admin_group, foreign_key: "admin_id"

  acts_as_voter

  has_attached_file :avatar,
    :styles => { :medium => "200x200#", :thumb => "100x100#", :status => "50x50#", :comment => "30x30#" },
    :default_url => ActionController::Base.helpers.asset_path('missing_:style.png')
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  def feed
    following_ids = "SELECT followed_id FROM relationships
                     WHERE  follower_id = :user_id"
    Status.status_not_group_and_event.where("user_id IN (#{following_ids})
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
    Myapp::Redis.new.exists("user_online_#{self.id}")
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
