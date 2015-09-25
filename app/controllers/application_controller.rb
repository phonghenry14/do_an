class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_action :authenticate_user!, :load_activity
  before_action :configure_permitted_parameters, if: :devise_controller?
  include UsersHelper
  include PublicActivity::StoreController

  protect_from_forgery with: :exception

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
  end

  def load_activity
    @old_activities_count = @old_activities_count || 0
    @activities = PublicActivity::Activity.where("recipient_id = ?", current_user.id).order('created_at DESC').limit(20)
    @new_activities_count = @activities.count - @old_activities_count
  end

  def viewed_activity
    @old_activities_count = @old_activities_count + @new_activities_count
    @new_activities_count = 0
  end
end
