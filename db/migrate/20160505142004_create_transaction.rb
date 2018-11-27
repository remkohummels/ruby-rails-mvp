class CreateTransaction < ActiveRecord::Migration
  def change
    create_table :transactions do |t|

      t.belongs_to :item
      t.belongs_to :user
      t.decimal :amount
      t.string :customer
      t.string :kind
      t.string :email
      t.string :paid
      t.string :status
      t.string :customer_ip

      t.timestamps null: false
    end
  end
end
