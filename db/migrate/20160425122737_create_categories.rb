class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.string  :name
      t.string  :slug
      t.integer :priority
      t.integer :parent_id, :null => true, :index => true
      t.integer :lft, :null => false, :index => true
      t.integer :rgt, :null => false, :index => true


      # optional fields
      t.integer :depth, :null => false, :default => 0
      t.integer :children_count, :null => false, :default => 0
    end
    add_index :categories, :slug, unique: true
  end

  def self.down
    drop_table :categories
  end
end
