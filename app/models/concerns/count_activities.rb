module CountActivities
  def initialize_activity
    Myapp::Redis.new.set("new_activity_#{self.id}", 0)
    Myapp::Redis.new.set("old_activity_#{self.id}", 0)
  end

  def load_activity
    if user_signed_in?
      @activities = PublicActivity::Activity.where("recipient_id = ?", current_user.id).order('created_at DESC')
      old_activity = Myapp::Redis.new.get("old_activity_#{current_user.id}")
      new_activity = @activities.count - old_activity.to_i
      Myapp::Redis.new.set("new_activity_#{current_user.id}", new_activity)
    end
  end

  def viewed_activity
    old_activity = Myapp::Redis.new.get("old_activity_#{current_user.id}")
    new_activity = Myapp::Redis.new.get("new_activity_#{current_user.id}")
    old_activity = old_activity.to_i + new_activity.to_i
    Myapp::Redis.new.set("old_activity_#{current_user.id}", old_activity)
    Myapp::Redis.new.set("new_activity_#{current_user.id}", 0)
  end
end
