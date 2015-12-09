class AddEventToStatus < ActiveRecord::Migration
  def change
    add_reference :statuses, :event
  end
end
