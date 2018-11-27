ActiveAdmin.register Withdraw do
  permit_params :amount, :card_number, :comment, :status


  form do |f|
    f.inputs "Transaction info" do
      f.input :status, :label => "Status", :as => :select, :collection => Withdraw.statuses.keys
      f.input :card_number
      f.input :amount
      f.input :comment
    end
    f.actions
  end
end
