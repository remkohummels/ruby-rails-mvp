class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :user_id
      t.integer :item_id

      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone
      t.string :country
      t.string :address
      t.string :city
      t.string :state
      t.string :zip
      t.float :amount

      t.timestamps null: false
    end
  end
end
