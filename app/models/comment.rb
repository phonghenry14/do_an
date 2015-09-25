class Comment < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: Proc.new { |controller, model| controller.current_user ? controller.current_user : nil },
    recipient: ->(controller, model) { model && model.status.user }


  mount_uploader :picture, PictureUploader

  belongs_to :user
  belongs_to :status

  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 140}
  validate  :picture_size

  default_scope -> {order(created_at: :desc)}

  acts_as_votable

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
