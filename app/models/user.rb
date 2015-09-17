class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :statuses, dependent: :destroy

  def feed
    Status.where("user_id = ?", id)
  end
end
