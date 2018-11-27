# == Schema Information
#
# Table name: notifications
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  content    :string           not null
#  is_new     :boolean          default(TRUE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Notification < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user, :content, :is_new

  scope :news, -> {where('is_new = ?', true)}
end
