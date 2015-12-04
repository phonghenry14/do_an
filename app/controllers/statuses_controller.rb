class StatusesController < ApplicationController
  before_action :correct_user, only: :destroy
  respond_to :html, :json

  def show
    @status = Status.find params[:id]
    @status.comments.build
    @user = current_user
    @user_list = current_user.following
  end

  def create
    @status = current_user.statuses.build status_params
    if @status.save
      flash[:success] = "Status created!"
      redirect_to root_url
    else
      @feed_items = []
      render "static_pages/home"
    end
  end

  def update
    @status = Status.find params[:id]
    @status.update_attributes status_params
    respond_with @status
  end

  def destroy
    @status.destroy
    flash[:success] = "Status deleted"
    redirect_to request.referrer || root_url
  end

  def like
    @status = Status.find params[:id]
    @status.liked_by current_user
    @status.create_activity key: "status.like"
    if @status.get_likes.size == (@status.try(:group).users.count)
      @status.done = true
      @status.save
      @status.create_activity key: "status.like"
    end
    if request.xhr?
      render json: {count: @status.get_likes.size, id: params[:id]}
    else
      redirect_to @status
    end
  end

  def unlike
    @status= Status.find params[:id]
    @status.unliked_by current_user
    @status.create_activity key: "status.unlike"
    if @status.get_likes.size < (@status.try(:group).users.count)
      @status.done = false
      @status.save
    end
    if request.xhr?
      render json: {count: @status.get_likes.size, id: params[:id]}
    else
      redirect_to @status
    end
  end

  private
  def status_params
    params.require(:status).permit :content, :picture
  end

  def correct_user
    @status = current_user.statuses.find_by id: params[:id]
    redirect_to root_url if @status.nil?
  end
end
