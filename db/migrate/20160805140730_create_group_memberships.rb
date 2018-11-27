class CreateGroupMemberships < ActiveRecord::Migration
  def change
    create_table :group_memberships do |t|
      t.belongs_to :user
      t.belongs_to :group
      t.string :status, default: 'pending'
      t.timestamps null: false
    end
  end
end
