class AddViewsCounterToItem < ActiveRecord::Migration
  def change
    add_column :items, :views_counter, :integer, default: 0
  end
end
