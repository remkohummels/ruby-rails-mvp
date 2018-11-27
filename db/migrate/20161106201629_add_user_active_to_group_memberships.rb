class AddUserActiveToGroupMemberships < ActiveRecord::Migration
  def change
    add_column :group_memberships, :active, :boolean, default: false
  end
end
