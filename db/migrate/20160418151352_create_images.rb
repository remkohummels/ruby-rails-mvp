class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :file
      t.string :temp_key
      t.belongs_to :item
      t.timestamps null: false
    end
  end
end
