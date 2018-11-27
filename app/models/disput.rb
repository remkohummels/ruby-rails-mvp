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

class Disput < ActiveRecord::Base
  belongs_to :user
  belongs_to :item
  belongs_to :winner, class_name: 'User', foreign_key: 'winner_id'
  has_many :comments, class_name: 'DisputComment', dependent: :destroy

  validates :reason, :description, presence: true

  def created_date
    self.created_at.strftime("%B %d, %Y %H:%I:%S")
  end
end
