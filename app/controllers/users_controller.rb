class UsersController < ApplicationController
  def show
    @user = User.find params[:id]
    @statuses = @user.statuses.paginate(page: params[:page])
  end
end
