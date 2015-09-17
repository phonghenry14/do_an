class StaticPagesController < ApplicationController
  def home
    @status = current_user.statuses.build if user_signed_in?
    @feed_items = current_user.feed.paginate(page: params[:page])
  end

  def help
  end

  def about
  end

  def contact
  end
end
