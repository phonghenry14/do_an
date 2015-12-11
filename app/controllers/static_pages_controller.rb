class StaticPagesController < ApplicationController
  def home
    @status = current_user.statuses.build
    @feed_items = current_user.feed.order(updated_at: :desc).paginate(page: params[:page])
    @user_list = current_user.following
    @feed_events = []
    current_user.events.each do |event|
      event.admin.statuses.status_in_event(event.id).each do |status|
        @feed_events << status
      end
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
