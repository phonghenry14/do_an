class AddGroupToStatuses < ActiveRecord::Migration
  def change
    add_reference :statuses, :group
  end
end
