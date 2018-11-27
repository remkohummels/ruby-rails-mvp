# == Schema Information
#
# Table name: disputs
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  reason         :string
#  description    :string
#  status         :string
#  winner_id      :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  item_id        :integer
#  resolve_reason :text
#

FactoryGirl.define do
  factory :disput do
    
  end

end
