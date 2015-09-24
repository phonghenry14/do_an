class CommentsController < ApplicationController

  def create
    @comment = Comment.new comment_params
    if @comment.save
      redirect_to :back
    end
  end

  def destroy
    @comment = Comment.find params[:id]
    @comment.destroy
    redirect_to :back
  end

  private
  def comment_params
    params.require(:comment).permit :status_id, :user_id, :content, :picture
  end

end
