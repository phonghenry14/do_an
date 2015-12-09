class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  def show
    @admin = @event.admin
    @event.statuses.build
    @feeds = []
    @event.users.each do|user|
      user.statuses.status_in_event(@event.id).each do |status|
        @feeds << status
      end
    end
    @user_list = @event.users
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new event_params
    @event.user_ids << current_user.id
    if @event.save
      UserEvent.create user_id: current_user.id, event_id: @event.id
      flash[:success] = "Event create success"
      redirect_to @event
    else
      flash[:danger] = "Create failed"
      render :new
    end
  end

  def update
    unless params[:confirm]
      if @event.update_attributes event_params
        flash[:success] = "Edited success"
        redirect_to @event
      else
        flash[:danger] = "Edit failed"
        render :edit
      end
    else
      @event.user_events.find_by_user_id(current_user.id).destroy
      flash[:success] = "Leave event successfully"
      redirect_to root_path
    end
  end

  def destroy
    @event.destroy
    flash[:success] = "Deleted success"
    redirect_to root_path
  end

  private
  def event_params
    params.require(:event).permit :name, :description, :admin_id, :time_start, :time_end,
      user_ids: [], user_events_attributes: [:id, :user_id, :event_id],
      statuses_attributes: [:id, :event_id, :user_id, :content, :picture]
  end

  def set_event
    @event = Event.find params[:id]
  end
end
