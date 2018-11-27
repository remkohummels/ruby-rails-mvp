# == Schema Information
#
# Table name: groups
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  title       :string
#  file        :string
#  description :text
#  status      :string           default("disabled")
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  rules       :string
#  terms       :string
#  country     :string
#  city        :string
#  banner      :string
#  state       :string
#

class Group < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  belongs_to :user
  
  has_many :item_group_relations
  has_many :items, through: :item_group_relations

  has_many :group_memberships, dependent: :destroy
  has_many :memberships, through: :group_memberships, :source => 'user', dependent: :destroy


  validates :title, presence: true
  validates :banner, presence: true
  validates :description, presence: true
  validates :terms, presence: true
  validate  :validate_banner

  mount_uploader :file, ImageUploader
  mount_uploader :banner, BannerUploader

  as_enum :status, [:disabled, :active], source: :status, map: :string

  scope :sort_by_popularity, ->{joins(:memberships).group("groups.id").order("count(groups.id) DESC")}
  after_create :add_user 
  after_create :get_location
  after_create :send_notifications

  before_save :activated?

  def validate_banner
    # if !self.banner_cache.nil? && (self.banner.width < 1500 || self.banner.height < 350)
    #   errors.add :banner, "Dimension too small. Minimum image requirements:  1500 X 350 pixels."
    # end
  end

  def get_location
    self.country = self.user.country
    self.state   = self.user.state
    self.city    = self.user.city
    self.save
  end

  def user_is_admin?(user)
    membership = GroupMembership.find_by(group_id: self.id, user_id: user.id)
    membership.present? && membership.admin?
  end

  def user_is_blocked?(user)
    membership = GroupMembership.find_by(group: self, user: user)
    membership.present? && membership.blcoked?
  end

  def provide_to_admin(user)
    membership = GroupMembership.find_by(group_id: self.id, user_id: user.id)
    membership.admin!
    membership.save
  end

  def demote_to_user(user)
    membership = GroupMembership.find_by(group_id: self.id, user_id: user.id)
    membership.user!
    membership.save
  end


  def group_admins
    admin_memberships = GroupMembership.where(group_id: self.id, role: :admin)
    admin_ids = admin_memberships.pluck(:user_id)
    admins = User.where(id: admin_ids).sort_by(&:full_name)
    return admins
  end

  def group_users
    user_memberships = GroupMembership.where(group_id: self.id, role: :user)
    user_ids = user_memberships.pluck(:user_id)
    users = User.where(id: user_ids).sort_by(&:full_name)
    return users
  end

  def block_user(user, admin)
    if user == admin || (self.user != admin && self.user_is_admin?(user))
      false
    else
      membership = self.group_memberships.find_by(user: user, status: 'joined')
      if membership.present? && membership.update(status: 'blocked')
        Message.create(
          sender: admin,
          recipient: user,
          title: self.title,
          body: "Dear #{user.full_name}, \nYou have been blocked from your group by the Group Admin for #{self.title}, for not complying with the Terms of Use and/or Code of Conduct. \nIf you want to reach your Group Admin, <a href='#{new_account_message_path(recipient_id: admin.id)}'>please email your Group Admin</a>."
        )
      else
        false
      end
    end
  end

  def unblock_user(user, admin)
    if user == admin || (self.user != admin && self.user_is_admin?(user))
      false
    else
      membership = self.group_memberships.find_by(user: user, status: 'blocked')
      if membership.present? && membership.update(status: 'joined')
        Message.create(
          sender: admin,
          recipient: user,
          title: self.title,
          body: "Dear #{user.full_name}, \nthe restriction for #{self.title} has been removed.  Welcome back!"
        )
      else
        false
      end
    end
  end

  def popularity
    self.memberships.count
  end

  private

  def send_notifications
    GroupMailer.new_group_approval(self).deliver_now
    if self.user
      GroupMailer.new_group(self.user, self).deliver_now
      self.user.notifications.create(content: "Access your new group <a href='#{group_path(self)}'>here</a>")
    end
  end

  def add_user
    self.user.group_memberships.create(group_id: self.id, status: 'joined', role: 'admin')
  end

  def activated?
    if self.status_changed?
      if self.active? && self.user
        self.user.notifications.create(content: "Group <a href='#{group_path(self)}'>#{self.title}</a> is approved")
        GroupMailer.group_approved(self.user, self).deliver_now
      end
    end
  end
end
