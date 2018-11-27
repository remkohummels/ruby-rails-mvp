ActiveAdmin.register FaqItem do
  menu label: "Help"

permit_params :question, :answer
  index do
    column :faqitem_id
    column :question
    column :answer
    actions
  end

  form do |f|
    f.inputs "FAQ" do
      f.input :question
      f.input :answer
    end
    f.actions
  end

end
