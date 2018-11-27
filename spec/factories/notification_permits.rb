# == Schema Information
#
# Table name: notification_permits
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  change_item :boolean          default(TRUE)
#  win_item    :boolean          default(TRUE)
#  close_item  :boolean          default(TRUE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryGirl.define do
  factory :notification_permit do
    
  end

end
