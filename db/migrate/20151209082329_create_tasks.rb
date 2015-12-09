class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.text :content
      t.integer :user_id
      t.integer :group_id
      t.datetime :deadline

      t.timestamps null: false
    end
  end
end
