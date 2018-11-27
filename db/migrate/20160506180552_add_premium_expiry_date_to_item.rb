class AddPremiumExpiryDateToItem < ActiveRecord::Migration
  def change
    add_column :items, :premium_expiry_date, :datetime
  end
end
