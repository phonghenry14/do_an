class Status < ActiveRecord::Base
  belongs_to :user
  belongs_to :group

  default_scope -> {order(created_at: :desc)}

  mount_uploader :picture, PictureUploader

  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 140}
  validate  :picture_size

  acts_as_commontable
  acts_as_votable

  scope :status_not_group, ->{where group_id: nil}
  scope :status_in_group, ->(group_id){where group_id: group_id}

  private
  # Validates the size of an uploaded picture.
  def picture_size
    if picture.size > 5.megabytes
      errors.add(:picture, "should be less than 5MB")
    end
  end
end
