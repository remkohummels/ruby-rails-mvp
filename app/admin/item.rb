ActiveAdmin.register Item do

  menu priority: 1
  config.per_page = 10

  permit_params :title, :image, :description, :keywords, :posting_type, :start_price, :buy_now_price, :reverse_price, :end_date, :location


  filter :title
  filter :description
  filter :keywords
  filter :start_price
  filter :buy_now_price
  filter :reverse_price
  filter :end_date
  filter :updated_at
  filter :created_at

  form do |f|
    f.inputs "User info" do
      f.input :title
      f.input :buy_now_price, min: 0
      f.input :start_price, min: 0
      f.input :keywords
      f.input :location
      f.input :end_date, :as => :datetime_picker
      f.input :description, :as => :text, input_html: {data: {provide: 'markdown'}}
      f.input :posting_type, :as => :select, :collection => enum_option_pairs(Item, Item.posting_types), include_blank: false
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
        i.images.each do |img|
          span do
            link_to admin_and_ben_image_path(img) do
              image_tag(img.file.small) if img
            end
          end
        end
      end
    end
    column :buy_now_price do |item|
      "#{item.start_price}$"
    end
    column :start_price do |item|
      "#{item.start_price}$"
    end
    column :reverse_price do |item|
      "#{item.reverse_price}$"
    end
    # column :keywords
    column :location
    column :description do |item|
      text = item.description.truncate(150)
      markdown text
    end
    column :posting_type
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :avatar do |i|
        div do
          i.images.each do |img|
            span do
              link_to root_path do
                image_tag(img.file.small) if img
              end
            end
          end
        end
      end
      row :title
      row :buy_now_price do |item|
        "#{item.buy_now_price || 0}$"
      end
      row :start_price do |item|
        "#{item.start_price}$"
      end
      row :reverse_price do |item|
        "#{item.reverse_price}$"
      end
      row :keywords
      row :description do |item|
        markdown item.description
      end
      row :location
      row :end_date
      row :updated_at
      row :created_at
    end
  end
end
