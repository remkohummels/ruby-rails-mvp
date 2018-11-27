class CreateBids < ActiveRecord::Migration
  def change
    create_table :bids do |t|

      t.integer :price
      t.references :user, index: true
      t.references :item, index: true

      t.timestamps null: false
    end
  end
end
