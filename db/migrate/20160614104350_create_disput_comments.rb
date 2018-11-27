class CreateDisputComments < ActiveRecord::Migration
  def change
    create_table :disput_comments do |t|
      t.belongs_to :disput
      t.belongs_to :user
      t.text :message
      t.timestamps null: false
    end
  end
end
