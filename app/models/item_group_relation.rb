# == Schema Information
#
# Table name: item_group_relations
#
#  id         :integer          not null, primary key
#  item_id    :integer
#  group_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ItemGroupRelation < ActiveRecord::Base
  belongs_to :item
  belongs_to :group

  validates :group, presence: true
  validates :item, presence: true, uniqueness: {scope: :group}

  after_destroy :remove_bids

  private

  def remove_bids
    users = User.all.joins(:group_memberships).where(group_memberships: {status: 'joined', group: self.item.groups}).uniq
    bids = self.item.bids.where.not(user: users)
    
    bids.each do |bid|
      bid.destroy
    end
  end
end
