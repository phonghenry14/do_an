class TasksController < ApplicationController
  before_action :correct_user, only: :destroy
  respond_to :html, :json

  def show
    @task = Task.find params[:id]
    @task.comments.build
    @user = current_user
    @user_list = current_user.following
  end

  def update
    @task = Task.find params[:id]
    @task.update_attributes task_params
    respond_with @task
  end

  def destroy
    @task.destroy
    flash[:success] = "Task deleted"
    redirect_to request.referrer || root_url
  end

  def like
    @task = Task.find params[:id]
    @task.liked_by current_user
    @task.create_activity key: "status.like"
    if request.xhr?
      render json: {count: @task.get_likes.size, id: params[:id]}
    else
      redirect_to @task
    end
  end

  def unlike
    @task= Task.find params[:id]
    @task.unliked_by current_user
    @task.create_activity key: "status.unlike"
    if request.xhr?
      render json: {count: @task.get_likes.size, id: params[:id]}
    else
      redirect_to @task
    end
  end

  private
  def status_params
    params.require(:task).permit :name, :content, :user_id, :deadline
  end

  def correct_user
    @task = current_user.tasks.find_by id: params[:id]
    redirect_to root_url if @task.nil?
  end
end
