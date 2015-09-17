class StaticPagesController < ApplicationController
  def home
    if user_signed_in?
      @status  = current_user.statuses.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
