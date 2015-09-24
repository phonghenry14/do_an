class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :status, index: true, foreign_key: true
      t.integer :user_id
      t.text :content
      t.string :picture

      t.timestamps
    end
  end
end
