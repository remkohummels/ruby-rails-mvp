class ChangeItemsFreeItem < ActiveRecord::Migration
  def change
    change_column :items, :free_item, :string, default: '0'
  end
end
