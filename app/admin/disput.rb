ActiveAdmin.register Disput do

  menu priority: 1
  config.per_page = 10

  filter :user_id, :as => :select, :collection => User.all
  filter :item_id, :as => :select, :collection => Item.all
  filter :winner
  filter :status
  filter :updated_at
  filter :created_at

  index do
    selectable_column
    id_column
    column :user do |d|
      link_to d.user.full_name, edit_admin_and_ben_user_path(d.user) unless d.user.blank?
    end
    column :item do |d|
      link_to d.item.title, edit_admin_and_ben_item_path(d.item) unless d.item.blank?
    end
    column :winner do |d|
      link_to d.winner.full_name, edit_admin_and_ben_user_path(d.winner) unless d.winner.blank?
    end
    column :status
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :user do |d|
        link_to d.user.full_name, edit_admin_and_ben_user_path(d.user) unless d.user.blank?
      end
      row :item do |d|
        link_to d.item.title, edit_admin_and_ben_item_path(d.item) unless d.item.blank?
      end
      row :winner do |d|
        link_to d.winner.full_name, edit_admin_and_ben_user_path(d.winner) unless d.winner.blank?
      end
      row :status
      row :resolve_reason
      row :updated_at
      row :created_at
    end
  end
end
