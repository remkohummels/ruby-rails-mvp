class AddFieldsToGroup < ActiveRecord::Migration
  def change
    add_column :groups, :country, :string  
    add_column :groups, :city,    :string
  end
end
