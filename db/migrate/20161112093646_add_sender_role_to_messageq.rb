class AddSenderRoleToMessageq < ActiveRecord::Migration
  def change
    remove_column :messages, :recipient_role, :string, default: 'buyer'
    add_column :messages, :sender_role, :string, default: 'buyer'
  end
end
