# == Schema Information
#
# Table name: payments
#
#  id            :integer          not null, primary key
#  amount        :float
#  user_id       :integer
#  item_id       :integer
#  created_at    :datetime
#  updated_at    :datetime
#

class Payment < ActiveRecord::Base
  belongs_to :user
  belongs_to :item

  validates :first_name, :last_name, :email, :phone, :country, :address, :city, :zip, presence: true
  validates :amount, presence: true
end
