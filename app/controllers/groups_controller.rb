class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy]

  def show
    @admin = @group.admin
    @statuses = @group.statuses.build
    @feeds = []
    @group.users.each do|user|
      user.statuses.status_in_group(@group.id).each do |status|
        @feeds << status
      end
    end
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new group_params
    @group.user_ids << current_user.id
    if @group.save
      UserGroup.create user_id: current_user.id, group_id: @group.id
      flash[:success] = "Group create success"
      redirect_to @group
    else
      flash[:danger] = "Create failed"
      render :new
    end
  end

  def update
    if @group.update_attributes group_params
      flash[:success] = "Edited success"
      redirect_to @group
    else
      flash[:danger] = "Edit failed"
      render :edit
    end
  end

  def destroy
    @group.destroy
    flash[:success] = "Deleted success"
    redirect_to root_path
  end

  private
  def group_params
    params.require(:group).permit :name, :description, :admin_id, user_ids: [],
      user_groups_attributes: [:id, :user_id, :group_id, :_destroy],
      statuses_attributes: [:id, :group_id, :user_id, :content, :picture, :_destroy]
  end

  def set_group
    @group = Group.find params[:id]
  end
end
