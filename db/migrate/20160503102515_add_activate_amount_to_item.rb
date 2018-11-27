class AddActivateAmountToItem < ActiveRecord::Migration
  def change
    add_column :items, :activate_amount, :integer
  end
end
