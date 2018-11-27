class AddOrdersCountToItem < ActiveRecord::Migration
  def change
    add_column :items, :orders_count, :integer, defaut: 0
  end
end
