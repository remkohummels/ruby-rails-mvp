# == Schema Information
#
# Table name: withdraws
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  amount      :decimal(, )
#  status      :string
#  card_number :string
#  comment     :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryGirl.define do
  factory :withdraw do
    user nil
amount ""
status "MyString"
card_number "MyString"
comment "MyText"
  end

end
