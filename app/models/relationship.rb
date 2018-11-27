# == Schema Information
#
# Table name: relationships
#
#  id          :integer          not null, primary key
#  follower_id :integer
#  followed_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Relationship < ActiveRecord::Base
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "Item"
  validates :follower_id, presence: true
  validates :followed_id, presence: true

  after_destroy :send_notification


  private

  def send_notification
    unless self.followed.is_a? Item
      if self.follower.present? && self.destroyed_by_association
        self.follower.notifications.create(content: "The item you are following has been removed by the Group Admins.")
      end
    end
  end

end
