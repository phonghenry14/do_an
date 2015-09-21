class RelationshipsController < ApplicationController
  def follow
    user = User.find(params[:id])
    current_user.follow(user)
    if request.xhr?
      render json: { count: user.followers.count, id: params[:id] }
    else
      redirect_to user
    end
  end

  def unfollow
    user = User.find(params[:id])
    current_user.unfollow(user)
    if request.xhr?
      render json: { count: user.followers.count, id: params[:id] }
    else
      redirect_to user
    end
  end
end
