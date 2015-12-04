class AddTaskToStatuses < ActiveRecord::Migration
  def change
    add_column :statuses, :task, :boolean
  end
end
