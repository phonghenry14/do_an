class UserGroupsController < ApplicationController
  def show
    @group = Group.find params[:group_id]
  end
end
