class Event < ActiveRecord::Base
  has_many :users, through: :user_events
  has_many :user_events, dependent: :destroy
  has_many :statuses, dependent: :destroy
  belongs_to :admin, class_name: "User"

  accepts_nested_attributes_for :user_events, allow_destroy: :true
  accepts_nested_attributes_for :statuses, allow_destroy: :true

  class << self
    def remove_old_event
      where("time_end < ?", DateTime.now).destroy_all
    end
  end
end
