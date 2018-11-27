ActiveAdmin.register User do

  menu priority: 1


  permit_params :email, :first_name, :last_name, :password, :password_confirmation,:balance

  index do
    selectable_column
    id_column
    column :email
    column :first_name
    column :last_name
    column :balance
    column :country
    column :state
    column :city
    column :created_at
    column :provider
    column :uid
    actions
  end

  filter :email
  filter :first_name
  filter :last_name
  filter :balance
  filter :updated_at
  filter :created_at
  filter :provider
  filter :uid

  form do |f|
    f.inputs "User info" do
      f.input :email
      f.input :first_name
      f.input :last_name
      f.input :balance
    end
    f.actions
  end
  show do
    attributes_table do
      row :id
      row :email
      row :first_name
      row :last_name
      row :provider
      row :uid
      row :updated_at
      row :created_at
    end
  end

end
