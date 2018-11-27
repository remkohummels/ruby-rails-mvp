class AddColumsToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :rules, :string
    add_column :groups, :terms, :string

  end
end
