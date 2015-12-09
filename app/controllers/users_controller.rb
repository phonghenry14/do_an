class UsersController < ApplicationController
  respond_to :html, :json

  def index
    @users = User.search params[:search]
    @groups = params[:search].present? ? Group.search(params[:search]) : nil
    @conversations = Conversation.involving(current_user).order "created_at DESC"
  end

  def show
    @user = User.find params[:id]
    @statuses = @user.statuses.status_not_group_and_event.paginate page: params[:page]
    @user_list = current_user.following
  end

  def update
    @user = User.find params[:id]
    @user.update_attributes(name: params[:user][:name])
    respond_with @user
  end

  def following
    @title = "Following"
    @user  = User.find params[:id]
    @users = @user.following.paginate page: params[:page]
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find params[:id]
    @users = @user.followers.paginate page: params[:page]
    render 'show_follow'
  end
end
