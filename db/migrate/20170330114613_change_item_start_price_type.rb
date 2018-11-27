class ChangeItemStartPriceType < ActiveRecord::Migration
  def change
    change_column :items, :start_price, :float
    change_column :items, :reverse_price, :float
    change_column :items, :shipping_price, :float 
    change_column :items, :buy_now_price, :float
  end
end
