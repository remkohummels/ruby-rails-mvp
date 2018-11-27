class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.references  :user,    null: false
      t.string      :content, null: false
      t.boolean     :is_new,  null: false, default: true

      t.timestamps null: false
    end
  end
end
