ActiveAdmin.register Image do
  actions :all, :except => [:edit, :new]
  menu priority: 1
  config.per_page = 10

  filter :item , :as => :select, :collection => Item.all
  filter :updated_at
  filter :created_at

  index do
    selectable_column
    id_column
    column :file do |i|
      image_tag i.file.thumb
    end
    column :item do |image|
      link_to image.item.title, edit_admin_and_ben_item_path(image.item) unless image.item.blank?
    end
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :file do |i|
        image_tag i.file.thumb
      end
      row :item do |image|
        link_to image.item.title, edit_admin_and_ben_item_path(image.item) unless image.item.blank?
      end
      row :updated_at
      row :created_at
    end
  end
end
