class CreateWithdraws < ActiveRecord::Migration
  def change
    create_table :withdraws do |t|
      t.references :user, index: true, foreign_key: true
      t.decimal :amount
      t.string :status
      t.string :card_number
      t.text :comment

      t.timestamps null: false
    end
  end
end
