class AddCurrencyIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :currency_id, :integer
  end
end
