class CreateDisputs < ActiveRecord::Migration
  def change
    create_table :disputs do |t|
      t.belongs_to :user
      t.string :reason
      t.string :description
      t.string :status
      t.integer :winner_id
      t.timestamps null: false
    end
  end
end
