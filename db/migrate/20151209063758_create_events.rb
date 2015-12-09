class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.text :description
      t.datetime :time_start
      t.datetime :time_end
      t.integer :admin_id

      t.timestamps null: false
    end
  end
end
