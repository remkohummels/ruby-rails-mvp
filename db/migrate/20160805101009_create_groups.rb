class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|

      t.belongs_to :user
      t.string :title
      t.string :file
      t.text :description
      t.string :status, default: 'active'

      t.timestamps null: false
    end
  end
end
