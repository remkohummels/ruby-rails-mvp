class AddBannerFieldToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :banner, :string
  end
end
