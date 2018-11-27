class AddCommunityToUsers < ActiveRecord::Migration
  def change
    add_column :users, :community, :string
  end
end
