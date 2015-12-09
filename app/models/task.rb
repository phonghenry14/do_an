class Task < ActiveRecord::Base
  belongs_to :user
  belongs_to :group

  has_many :comments, dependent: :destroy

  accepts_nested_attributes_for :comments, allow_destroy: :true

  validates :user_id, presence: true
  validates :group_id, presence: true
  validates :content, presence: true, length: {maximum: 2000}

  scope :task_in_group, ->(group_id){where group_id: group_id}

  acts_as_votable
end
