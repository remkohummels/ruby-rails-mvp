class RenamePriseToPrice < ActiveRecord::Migration
  def change
    rename_column :items, :start_prise, :start_price
    rename_column :items, :reverse_prise, :reverse_price
  end
end
