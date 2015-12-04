class AddDoneToStatuses < ActiveRecord::Migration
  def change
    add_column :statuses, :done, :boolean
  end
end
