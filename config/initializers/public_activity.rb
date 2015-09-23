PublicActivity::Activity.class_eval do
  scope :user_activities, ->user_id{where("owner_id = ?", user_id)}
  scope :recent, ->{order "created_at DESC"}
end
