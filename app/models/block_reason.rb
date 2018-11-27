# == Schema Information
#
# Table name: block_reasons
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  group_id   :integer          not null
#  reason     :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class BlockReason < ActiveRecord::Base
  belongs_to :user
  belongs_to :group

  validates_presence_of :user, :group, :reason
end
