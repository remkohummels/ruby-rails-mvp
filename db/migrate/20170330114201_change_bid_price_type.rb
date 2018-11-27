class ChangeBidPriceType < ActiveRecord::Migration
  def change
    change_column :bids, :price, :float
  end
end
