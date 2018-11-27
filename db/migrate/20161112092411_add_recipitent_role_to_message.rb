class AddRecipitentRoleToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :recipient_role, :string, default: 'buyer'
  end
end
