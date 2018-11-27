class CreateNotificationPermits < ActiveRecord::Migration
  def change
    create_table :notification_permits do |t|
      t.integer :user_id
      t.boolean :change_item, default: true
      t.boolean :win_item, default: true
      t.boolean :close_item, default: true

      t.timestamps null: false
    end
  end
end
