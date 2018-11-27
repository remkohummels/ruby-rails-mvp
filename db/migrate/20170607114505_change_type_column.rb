class ChangeTypeColumn < ActiveRecord::Migration
  def change
    remove_column :items, :type
    add_column :items, :posting_type, :string
  end
end
