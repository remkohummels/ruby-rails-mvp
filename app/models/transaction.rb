# == Schema Information
#
# Table name: transactions
#
#  id          :integer          not null, primary key
#  item_id     :integer
#  user_id     :integer
#  amount      :decimal(, )
#  customer    :string
#  kind        :string
#  email       :string
#  paid        :string
#  status      :string
#  customer_ip :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Transaction < ActiveRecord::Base

  belongs_to :user
  belongs_to :item

  as_enum :kind, [:buy, :activate, :premium], source: :kind, map: :string
  as_enum :paid, [:true, :false], source: :paid, map: :string

  scope :activate, -> { where(kind: 'activate') }
  scope :buy, -> { where(kind: 'buy') }
end
