# == Schema Information
#
# Table name: group_memberships
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  group_id   :integer
#  status     :string           default("pending")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  active     :boolean          default(FALSE)
#  role       :string           default("user")
#

class GroupMembership < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  belongs_to :user
  belongs_to :group

  validates :group, presence: true
  validates :user, presence: true, uniqueness: {scope: :group}

  scope :not_pending, -> { where.not(status: 'pending') }

  as_enum :status, [:pending, :joined, :blocked], source: :status, map: :string
  as_enum :role, [:user, :admin], source: :role, map: :string
  after_save :send_notification
  after_save :remove_item_group_relation_and_bids

  def active!
    if self.user.can_choose? != false
      self.active = true
      self.save
    else
      self.user.group_memberships.update_all(active: false)
      self.active = true
      self.save
    end
  end

  def not_active!
    self.active = false
    self.save
  end

  private

  def send_notification
    if self.created_at == self.updated_at && self.status.to_s == 'pending'
      GroupMailer.join_request(self.user, self.group).deliver_now
      if self.group.user
        GroupMailer.new_user(self.group.user, self.group).deliver_now
      end

      self.group.group_admins.each do |group_admin|
        group_admin.notifications.create(content: "#{self.user.first_name} has requested to join group <a href='#{group_path(self.group)}'>#{self.group.title}</a>")
      end
    end

    if self.changes[:status]
      before_status = self.changes[:status].first.to_s
      after_status = self.changes[:status].last.to_s

      if before_status == 'pending' && after_status == 'joined'
        self.user.notifications.create(content: "Your request to join <a href='#{group_path(self.group)}'>#{self.group.title}</a> has been approved")
      end
    end

    if self.changes[:role] && self.role == 'admin'
      self.user.notifications.create(content: "You have been appointed as group admin for <a href='#{group_path(self.group)}'>#{self.group.title}</a>")
    end
  end

  def remove_item_group_relation_and_bids
    if self.changes[:status] && self.status.to_s == 'blocked'
      items = self.user.items.active.where(posting_type: 'group_post')
      items.each do |item|
        item_group_relation = item.item_group_relations.find_by(group: self.group)
        item_group_relation.destroy if item_group_relation.present?

        item.destroy if ItemGroupRelation.where(item: item).empty?
      end

      group_items = Item.active.where(posting_type: 'group_post').joins(:item_group_relations).where(item_group_relations:{group: self.group})
      group_items.each do |item|
        if !self.user.is_joined_groups?(item.groups)
          item.bids.where(user: self.user).each do |bid|
            bid.destroy
          end
        end
      end
    end
  end

end
