class StatusesController < ApplicationController
  before_action :correct_user, only: :destroy

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
    if @status.update_attributes status_params
      redirect_to :back
    end
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
