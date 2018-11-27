ActiveAdmin.register Bid do

  menu priority: 1
  config.per_page = 10

  filter :user_id, :as => :select, :collection => User.all
  filter :item_id, :as => :select, :collection => Item.all
  filter :updated_at
  filter :created_at

  index do
    selectable_column
    id_column
    column :user do |bid|
      link_to bid.user.full_name, edit_admin_and_ben_user_path(bid.user) unless bid.user.blank?
    end
    column :item do |bid|
      link_to bid.item.title, edit_admin_and_ben_item_path(bid.item) unless bid.item.blank?
    end
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :user do |bid|
        link_to bid.user.full_name, edit_admin_and_ben_user_path(bid.user) unless bid.user.blank?
      end
      row :item do |bid|
        link_to bid.item.title, edit_admin_and_ben_item_path(bid.item) unless bid.item.blank?
      end
      row :updated_at
      row :created_at
    end
  end
end
