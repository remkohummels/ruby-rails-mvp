class AddImagesCountToItem < ActiveRecord::Migration
  def change
    add_column :items, :images_count, :integer, default: 0
  end
end
