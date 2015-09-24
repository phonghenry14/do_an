class StaticPagesController < ApplicationController
  def home
    @status = current_user.statuses.build
    @feed_items = current_user.feed.paginate(page: params[:page])
    @user_list = current_user.following
  end

  def help
  end

  def about
  end

  def contact
  end
end
