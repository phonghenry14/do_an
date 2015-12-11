class CommentsController < ApplicationController
  respond_to :html, :json

  def create
    @comment = Comment.create! comment_params
    respond_to do |format|
      format.html { }
      format.js
    end
  end

  def update
    @comment = Comment.find params[:id]
    @comment.update_attributes comment_params
    respond_with @comment
  end

  def destroy
    @comment = Comment.find params[:id]
    @comment.destroy
    redirect_to :back
  end

  private
  def comment_params
    params.require(:comment).permit :status_id, :task_id, :user_id, :content, :picture
  end
end
