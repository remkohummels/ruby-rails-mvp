ActiveAdmin.register Group do

  menu priority: 1
  config.per_page = 10

  permit_params :title, :file, :description, :status


  filter :title
  filter :description

  filter :status
  form do |f|
    f.inputs "User info" do
      f.input :title
      f.input :description, :as => :text
      f.input :status, :as => :select, :collection => Group.statuses.map{|s| s.first}
    end
    f.actions
  end

  index do
    selectable_column
    id_column
    column :title
    column :user do |i|
      link_to i.user.full_name, admin_and_ben_user_path(i.user) unless i.user.blank?
    end
    column :image, width: "1500px" do |i|
      div do
        span do
          link_to admin_and_ben_group_path(i) do
            image_tag(i.file.small) if i.file
          end
        end
      end
    end
    column :description do |item|
      text = item.description.truncate(150)
      markdown text
    end
    column :status
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :image do |i|
        div do
          span do
            link_to admin_and_ben_group_path(i) do
              image_tag(i.file.small) if i.file
            end
          end
        end
      end
      row :title
      row :description do |item|
        markdown item.description
      end
      row :updated_at
      row :created_at
    end
  end
end
