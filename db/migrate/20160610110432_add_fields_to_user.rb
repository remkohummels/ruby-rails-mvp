class AddFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :website, :string
    add_column :users, :country, :string
    add_column :users, :phone, :string
  end
end
