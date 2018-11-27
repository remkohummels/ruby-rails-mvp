class CreateBlockReasons < ActiveRecord::Migration
  def change
    create_table :block_reasons do |t|
      t.references :user, null: false
      t.references :group, null: false
      t.string  :reason, null: false

      t.timestamps null: false
    end
  end
end
