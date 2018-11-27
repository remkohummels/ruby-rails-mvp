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

class Withdraw < ActiveRecord::Base
  belongs_to :user

  validates :card_number, :amount, presence: true
  validates :amount, :numericality => {:allow_blank => true}

  as_enum :status, [:unpaid, :paid], source: :status, map: :string

  before_create :set_defaults
  before_save   :check_if_paid

  def set_defaults
    self.status ||= :unpaid
  end

  def check_if_paid
    if status_changed? && status == :paid
      user = self.user
      user.balance = user.balance - self.amount
      user.save()
    end
  end
end
