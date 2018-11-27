class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :title
      t.string :description
      t.integer :start_prise
      t.integer :reverse_prise
      t.string :condition

      t.timestamps null: false
    end
  end
end
