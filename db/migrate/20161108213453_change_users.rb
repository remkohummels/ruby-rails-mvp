class ChangeUsers < ActiveRecord::Migration
  def change
    remove_column :users, :currency_id, :integer
    add_column :users, :currency_id, :integer, default: 1
  end
end
