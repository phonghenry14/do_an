class Status < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: Proc.new {|controller, model| controller.current_user ? controller.current_user : nil},
    recipient: ->(controller, model) { model && model.user }

  belongs_to :user
  belongs_to :group
  belongs_to :event

  has_many :comments, dependent: :destroy

  accepts_nested_attributes_for :comments, allow_destroy: :true

  default_scope -> {order(created_at: :desc)}

  mount_uploader :picture, PictureUploader

  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 2000}
  validate  :picture_size

  acts_as_votable

  scope :status_not_group_and_event, ->{where group_id: nil, event_id: nil}
  scope :status_in_group, ->(group_id){where group_id: group_id}
  scope :status_in_event, ->(event_id){where event_id: event_id}

  def name
    content.split(//).first(30).join
  end

  private
  # Validates the size of an uploaded picture.
  def picture_size
    if picture.size > 5.megabytes
      errors.add(:picture, "should be less than 5MB")
    end
  end
end
