class Comment < ActiveRecord::Base
  include PublicActivity::Model

  mount_uploader :picture, PictureUploader

  belongs_to :user
  belongs_to :status
  belongs_to :tasks

  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 140}
  validate  :picture_size

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
