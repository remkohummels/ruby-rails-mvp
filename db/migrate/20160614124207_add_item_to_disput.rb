class AddItemToDisput < ActiveRecord::Migration
  def change
    add_column :disputs, :item_id, :integer
  end
end
