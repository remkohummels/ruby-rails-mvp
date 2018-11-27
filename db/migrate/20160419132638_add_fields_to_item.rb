class AddFieldsToItem < ActiveRecord::Migration
  def change
    add_column :items, :type, :string
    add_column :items, :buy_now_price, :integer
    add_column :items, :shipping_price, :integer
  end
end
