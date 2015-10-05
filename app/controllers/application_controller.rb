class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :load_activity
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_filter :set_online

  include UsersHelper
  include PublicActivity::StoreController
  include CountActivities

  protect_from_forgery with: :exception

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name

    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:name, :email, :password,
      :password_confirmation, :current_password, :avatar) }
  end

  def set_online
    if !!current_user
      Myapp::Redis.new.set("user_online_#{current_user.id}", nil, ex: 5*60)
    end
  end
end
