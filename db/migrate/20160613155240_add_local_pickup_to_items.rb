class AddLocalPickupToItems < ActiveRecord::Migration
  def change
    add_column :items, :pickup, :string
  end
end
