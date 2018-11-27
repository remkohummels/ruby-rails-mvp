ActiveAdmin.register Message do
  menu label: "Support"

  controller do
    def scoped_collection
      super.where(recipient_type: AdminUser).order(created_at: :desc)
    end
  end

  permit_params :title, :body, :sender_id, :recipient_id, :status, :sender_role
  index do
    column :id
    column :title
    column :sender_email
    column :body
    column :status
    column 'Sent Date', :created_at
    actions
  end

  form do |f|
    f.inputs "New Message" do
      f.input :title
      f.input :sender_id, :input_html => { :value => 0 }, as: :hidden
      f.input :recipient_id, :as => :select, :collection => User.all.map{|u| [u.email, u.id]}
      f.input :body
      f.input :sender_role, :input_html => { :value => :admin }, as: :hidden
      f.input :status, :as => :select, :collection => Message.statuses.map{|s| s.first}
    end
    f.actions
  end

end


# ActiveAdmin.register Message do
#   menu label: "Messages"

#   permit_params :title, :body, :sender_id, :recipient_id, :status, :sender_role
#   index do
#     column :message_id
#     column :title
#     column :sender_id
#     column :recipient_id
#     column :body
#     column :sender_role
#     column :status
#     actions
#   end

#   form do |f|
#     f.inputs "FAQ" do
#       f.input :title
#       f.input :sender_id, :as => :select, :collection => User.all.map{|u| [u.email, u.id]}
#       f.input :recipient_id, :as => :select, :collection => User.all.map{|u| [u.email, u.id]}
#       f.input :body
#       f.input :sender_role, :as => :select, :collection => Message.sender_roles.map{|r| r.first}
#       f.input :status, :as => :select, :collection => Message.statuses.map{|s| s.first}
#     end
#     f.actions
#   end

# end
