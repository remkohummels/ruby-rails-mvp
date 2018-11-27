class AddNamesToAdminUsers < ActiveRecord::Migration
  def change
    add_column :admin_users, :first_name, :string
    add_column :admin_users, :last_name, :string
    AdminUser.find_each do |au|
      if au.first_name.nil?
        au.first_name = 'Admin'
        au.last_name = 'User'
        au.save
      end
    end
  end
end
