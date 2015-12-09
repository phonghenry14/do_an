class AddTaskToComments < ActiveRecord::Migration
  def change
    add_column :comments, :task_id, :integer
  end
end
