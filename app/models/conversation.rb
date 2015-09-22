class Conversation < ActiveRecord::Base
  belongs_to :sender, class_name: User.name, foreign_key: :sender_id
  belongs_to :receiver, class_name: User.name, foreign_key: :receiver_id

  has_many :messages, dependent: :destroy

  validates_uniqueness_of :sender_id, scope: :receiver_id

  scope :involving, ->(user) do
    where("sender_id = ? OR receiver_id = ?", user.id, user.id)
  end

  scope :existing_conversation, ->(sender_id, receiver_id) do
    where("(sender_id = ? AND receiver_id = ?) OR (sender_id = ? AND receiver_id = ?)",
      sender_id, receiver_id, receiver_id, sender_id)
  end
end
