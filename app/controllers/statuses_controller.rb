class StatusesController < ApplicationController
  before_action :correct_user, only: :destroy

  def create
    @status = current_user.statuses.build(status_params)
    if @status.save
      flash[:success] = "Status created!"
      redirect_to root_url
    else
      @feed_items = []
      render "static_pages/home"
    end
  end

  def destroy
    @status.destroy
    flash[:success] = "Status deleted"
    redirect_to request.referrer || root_url
  end

  private
  def status_params
    params.require(:status).permit(:content, :picture)
  end

  def correct_user
    @status = current_user.statuses.find_by id: params[:id]
    redirect_to root_url if @status.nil?
  end
end
