# == Schema Information
#
# Table name: feedbacks
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  item_id    :integer
#  title      :string
#  text       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Feedback < ActiveRecord::Base
  belongs_to :user
  belongs_to :item
  validates :title, :text, presence: true
end
