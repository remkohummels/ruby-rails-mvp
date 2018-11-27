class AddWinnerToItem < ActiveRecord::Migration
  def change
    add_column :items, :winner_id, :integer
  end
end
