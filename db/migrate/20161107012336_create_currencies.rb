class CreateCurrencies < ActiveRecord::Migration
  def change
    create_table :currencies do |t|
      t.string :name
      t.float :course  # to dollar
      t.timestamps null: false
    end
  end
end
