class UsersController < ApplicationController
  def index
    @users = User.paginate page: params[:page]
    @conversations = Conversation.involving(current_user).order "created_at DESC"
  end

  def show
    @user = User.find params[:id]
    @statuses = @user.statuses.paginate page: params[:page]
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
