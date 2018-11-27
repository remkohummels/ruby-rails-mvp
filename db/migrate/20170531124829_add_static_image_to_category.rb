class AddStaticImageToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :static_image, :string
  end
end
