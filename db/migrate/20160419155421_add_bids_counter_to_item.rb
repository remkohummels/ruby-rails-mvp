class AddBidsCounterToItem < ActiveRecord::Migration
  def change
    add_column :items, :bids_count, :integer, :default => 0
  end
end
