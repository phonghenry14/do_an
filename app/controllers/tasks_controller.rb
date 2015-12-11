class TasksController < ApplicationController
  respond_to :html, :json

  def show
    @task = Task.find params[:id]
    @task.comments.build
    @user = current_user
    @user_list = current_user.following
  end

  def update
    @task = Task.find params[:id]
    if params[:task][:done]
      @task.done = params[:task][:done]
      @task.save
      redirect_to @task.group
    else
      @task.update_attributes task_params
      respond_with @task
    end
  end

  def destroy
    @task = Task.find params[:id]
    @task.destroy
    flash[:success] = "Task deleted"
    redirect_to request.referrer || root_url
  end

  private
  def task_params
    params.require(:task).permit :name, :content, :user_id, :deadline, :done
  end
end
