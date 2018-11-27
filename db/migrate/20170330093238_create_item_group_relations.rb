class CreateItemGroupRelations < ActiveRecord::Migration
  def change
    create_table :item_group_relations do |t|
      t.integer :item_id
      t.integer :group_id
      t.timestamps null: false
    end
  end
end
