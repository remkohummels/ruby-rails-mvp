ActiveAdmin.register Transaction do
  permit_params :amount, :paid, :status, :customer_ip

  index do
    selectable_column
    id_column
    column :item do |t|
      link_to t.item.title, admin_item_path(t.user) if t.item.present?
    end
    column :user do |t|
      link_to t.user.full_name, admin_and_ben_user_path(t.user) if t.user.present?
    end
    column :email
    column :amount
    column :customer
    column :customer_ip
    column :kind
    column :paid
    column :status
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :item do |t|
        link_to t.item.title, admin_item_path(t.user) if t.item.present?
      end
      row :user do |t|
        link_to t.user.full_name, admin_and_ben_user_path(t.user) if t.user.present?
      end
      row :email
      row :amount
      row :customer
      row :customer_ip
      row :kind
      row :paid
      row :status
      row :created_at
      row :updated_at
    end
  end

  filter :user_id, :as => :select, :collection => User.all
  filter :item_id, :as => :select, :collection => Item.all
  filter :paid, :as => :select, :collection => Transaction.paids.keys
  filter :kind, :as => :select, :collection => Transaction.kinds.keys
  filter :email
  filter :status
  filter :amount


  form do |f|
    f.inputs "Transaction info" do
      f.input :status
      f.input :amount
      f.input :paid, :label => "Paid", :as => :select, :collection => Transaction.paids.keys
      f.input :kind, :label => "Kind", :as => :select, :collection => Transaction.kinds.keys
    end
    f.actions
  end
end
