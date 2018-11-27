# == Schema Information
#
# Table name: disput_comments
#
#  id         :integer          not null, primary key
#  disput_id  :integer
#  user_id    :integer
#  message    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :disput_comment do
    
  end

end
