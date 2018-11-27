class AddFreeItemToItems < ActiveRecord::Migration
  def change
    add_column :items, :free_item, :string
  end
end
