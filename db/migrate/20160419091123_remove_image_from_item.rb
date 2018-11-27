class RemoveImageFromItem < ActiveRecord::Migration
  def change
    remove_column :items, :image, :string
  end
end
