# == Schema Information
#
# Table name: items
#
#  id                  :integer          not null, primary key
#  title               :string
#  description         :string
#  start_price         :float
#  reverse_price       :float
#  condition           :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  keywords            :string
#  user_id             :integer
#  buy_now_price       :float
#  shipping_price      :float
#  bids_count          :integer          default(0)
#  end_date            :datetime
#  winner_id           :integer
#  category_id         :integer
#  status              :string           default("pending")
#  activate_amount     :integer
#  views_counter       :integer          default(0)
#  premium_expiry_date :datetime
#  images_count        :integer          default(0)
#  website             :string
#  free_item           :string           default("0")
#  pickup              :string
#  group_id            :integer
#  orders_count        :integer
#  location            :string
#  posting_type        :string
#

FactoryGirl.define do
  factory :item do
    
  end

end
