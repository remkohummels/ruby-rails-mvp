class RemoveEndDateFromItem < ActiveRecord::Migration
  def change
    change_column_default(:items, :end_date, nil)
  end
end
