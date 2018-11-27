class AddColumnsToItem < ActiveRecord::Migration
  def change
    add_column :items, :availability, :string
    add_column :items, :rent_item_location, :string
    add_column :items, :rent_item_condition, :string
    add_column :items, :instruction, :string
    add_column :items, :service, :float, default: 0

    add_column :items, :hourly_rate, :float, default: 0
    add_column :items, :daily_rate, :float, default: 0
    add_column :items, :weekly_rate, :float, default: 0
    add_column :items, :hold_amount, :float, default: 0
    add_column :items, :accept_term, :boolean, default: false
  end
end
