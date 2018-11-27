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

class DisputComment < ActiveRecord::Base
  belongs_to :user
  belongs_to :disput
  validates  :message, :user_id, :disput_id, presence: true
end
