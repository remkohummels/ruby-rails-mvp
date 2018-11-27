class AddStatusToItem < ActiveRecord::Migration
  def up
    add_column :items, :status, :string, default: 'pending'
    Item.unscoped.where('end_date < ?', DateTime.now).update_all(status: 'finished')
  end

  def down
    remove_column :items, :status
  end
end
