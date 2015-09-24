class UsersController < ApplicationController
  def index
    @users = User.search params[:search]
    @groups = params[:search].present? ? Group.search(params[:search]) : nil
    @conversations = Conversation.involving(current_user).order "created_at DESC"
  end

  def show
    @user = User.find params[:id]
    @statuses = @user.statuses.status_not_group.paginate page: params[:page]
    @user_list = current_user.following
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
