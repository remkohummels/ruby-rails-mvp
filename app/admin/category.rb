ActiveAdmin.register Category do
  permit_params :name,:parent_id,:lft,:rgt,:depth,:slug, :priority, :image, :color

  config.sort_order = 'priority_asc' # assumes you are using 'position' for your acts_as_list column
  config.paginate   = false # optional; drag-and-drop across pages is not supported
  sortable # creates the controller action which handles the sorting

  index do
    selectable_column
    sortable_handle_column # inserts a drag handle
    id_column
    column :name
    column :parent
    column :priority
    column :image do |i|
      image_tag i.image_url(:thumb)
    end
    column :color
    actions
  end

  show do
    attributes_table do
      row :name
      row :parent
      row :priority
      row :image do |i|
        image_tag i.image_url(:thumb)
      end
      row :color
    end
  end

  filter :name
  filter :slug
  filter :parent

  form do |f|
    f.inputs "Category info" do
      f.input :name
      f.input :parent_id,   :label => "Parent category",:as => :select, :collection => nested_set_options(Category, @category) {|i| "#{'-' * i.level} #{i.name}" }
      f.input :image #, :hint => image_tag(f.object.image.url(:thumb))
      f.input :color, input_html: { placeholder: "#hex" } 
    end
    f.submit
  end

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end


end
