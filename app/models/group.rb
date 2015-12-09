class Group < ActiveRecord::Base
  after_save :load_into_soulmate
  before_destroy :remove_from_soulmate

  has_many :users, through: :user_groups
  has_many :user_groups, dependent: :destroy
  has_many :statuses, dependent: :destroy
  has_many :tasks, dependent: :destroy
  belongs_to :admin, class_name: "User"

  accepts_nested_attributes_for :user_groups, allow_destroy: :true
  accepts_nested_attributes_for :statuses, allow_destroy: :true
  accepts_nested_attributes_for :tasks, allow_destroy: :true

  def self.search search
    if search
      Group.where("name LIKE ?", "%#{search}%")
    else
      Group.all
    end
  end

  private

  def load_into_soulmate
    loader = Soulmate::Loader.new("groups")
    loader.add("term" => name, "id" => self.id, "data" => {
      "link" => Rails.application.routes.url_helpers.group_path(self)
      })
  end

  def remove_from_soulmate
    loader = Soulmate::Loader.new("groups")
    loader.remove("id" => self.id)
  end
end
