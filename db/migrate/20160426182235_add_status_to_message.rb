class AddStatusToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :status, :string, default: 'new'
    remove_column :messages, :read
  end
end
