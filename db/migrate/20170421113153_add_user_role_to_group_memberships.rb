class AddUserRoleToGroupMemberships < ActiveRecord::Migration
  def change
    add_column :group_memberships, :role, :string, default: 'user'
  end
end
