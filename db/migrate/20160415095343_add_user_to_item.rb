class AddUserToItem < ActiveRecord::Migration
  def change
    add_reference :items, :user, index: true
  end
end
