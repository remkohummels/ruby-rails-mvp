class AddEndDateToItem < ActiveRecord::Migration
  def change
    add_column :items, :end_date, :datetime, :default => Time.now + 30.days
  end
end
