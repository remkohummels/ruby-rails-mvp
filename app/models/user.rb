# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  status                 :string           default("active")
#  first_name             :string
#  last_name              :string
#  role                   :string
#  balance                :decimal(, )      default(0.0)
#  password_reset_token   :string
#  password_reset_sent_at :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  website                :string
#  country                :string
#  phone                  :string
#  about                  :text
#  provider               :string
#  uid                    :string
#  referral               :string
#  city                   :string
#  community              :string
#  currency_id            :integer          default(1)
#  avatar_url             :string
#  state                  :string
#

class User < ActiveRecord::Base
  has_one :rating, class_name: 'RatingCache', foreign_key: 'cacheable_id'
  has_one :notification_permit
  belongs_to :currency

  has_many :items, dependent: :destroy
  has_many :images
  has_many :transactions
  has_many :bids
  has_many :feedbacks, dependent: :destroy
  # Mesages
  has_many :sent_messages, -> { where sender_type: "User"},
          class_name: Message, foreign_key: :sender_id, dependent: :destroy
  has_many :received_messages, -> { where recipient_type: "User"},
           class_name: Message, foreign_key: :recipient_id, dependent: :destroy

  # Notifications
  has_many :notifications, dependent: :destroy
  # Disputs
  has_many :disputs
  has_many :disput_comments
  # Groups
  has_many :groups
  has_many :group_memberships, dependent: :destroy
  has_many :invite_groups, :through => :group_memberships, :source => 'group'

  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_items, through: :relationships, source: :followed

  has_many :winned_items, foreign_key: 'winner_id', class_name: 'Item'


  as_enum :status, [:active, :disabled], source: :status, map: :string
  as_enum :role, [:admin, :manager, :user], source: :role, map: :string
  validates :first_name, :last_name, presence: true
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable,
         :omniauthable,
         omniauth_providers: [:facebook, :twitter]

  scope :active, -> {}
  scope :messagable, -> (current_user_id) { where.not id: current_user_id }

  mount_uploader :avatar_url, ImageUploader

  acts_as_voter
  ratyrate_rater
  ratyrate_rateable "consumer", "seller"

  before_create :create_notification_permit

  def create_notification_permit
    self.notification_permit = NotificationPermit.new
  end

  def get_location
    geo = GeoIpService.new(ip: self.current_sign_in_ip.to_s)
    location = geo.get_location
    self.country = location['country']
    self.state   = location['region']
    self.city    = location['city']
    self.save
  end

  def active_groups
    group_list = []
    self.group_memberships.where(active: true).each do |gm|
      group_list << gm.group
    end 
    return group_list
  end

  def is_group_member?
    self.group_memberships.where(status: :joined).any?
  end

  def is_joined_groups?(groups)
    self.group_memberships.where(status: :joined, group: groups).any?
  end

  def is_blocked_groups?(groups)
    self.group_memberships.where(status: :blocked, group: groups).any?
  end

  def can_choose?
    if self.active_groups.count < 1
      return (1 - self.active_groups.count)
    else
      return false
    end
  end
  
  def choose_group(group)
    rel = self.group_memberships.find_by(group_id: group.id)
    rel.active!
  end
  #Following
  def following?(item)
    relationships.find_by(followed_id: item.id)
  end

  def follow!(item)
    relationships.create!(followed_id: item.id)
  end

  def unfollow!(item)
    relationships.find_by(followed_id: item.id).destroy!
  end

# Owerride default behaviors
  def self.new_with_session(params, session)
    if session["devise.twitter_data"]
      new(session["devise.twitter_data"], without_protection: true) do |user|
        user.attributes = params
        user.valid?
      end
    elsif session["devise.facebook_data"]
      new(session["devise.facebook_data"], without_protection: true) do |user|
        user.attributes = params
        user.valid?
      end
    else
      super
    end
  end

  def password_required?
    super && provider.blank?
  end

#######
  def self.from_omniauth_facebook(auth)
    user = User.find_by_email auth.info.email
    if user
      user.provider              = auth.provider
      user.uid                   = auth.uid
      user.remote_avatar_url_url = auth.info.image.gsub('http://','https://')
      user.save
      return user
    else
      user = User.where(provider: auth.provider, uid: auth.uid).first_or_create
      user.email                 = auth.info.email if user.email.blank?
      user.remote_avatar_url_url = auth.info.image.gsub('http://','https://')
      user.password              = Devise.friendly_token[0, 20]
      user.first_name            = auth.extra.raw_info.first_name
      user.last_name             = auth.extra.raw_info.last_name
      user.save
      return user
    end
  end

  def self.from_omniauth_twitter(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.password = Devise.friendly_token[0, 20]
      name = auth.info.name.split(' ')
      if name.count > 1
        user.first_name = name[0]
        user.last_name = name[1]
      else
        user.first_name = auth.info.name
        user.last_name = auth.info.name
      end
    end
  end

  def group_active(group)
    group_memberships = self.group_memberships.where group_id: group.id
    if !group_memberships.blank?
      group_memberships.first.active
    else
      false
    end
  end

  def joined_groups
    Group.joins(:group_memberships).where(group_memberships: {status: 'joined', user: self})
  end

  def group_status(group)
    group_memberships = self.group_memberships.where group_id: group.id
    if !group_memberships.blank?
      group_memberships.first.status.to_s
    else
      ''
    end
  end

  def in_group?(group)
    val = false
    group_memberships = self.group_memberships.where group_id: group.id
    if !group_memberships.blank?
      val = group_memberships.first.status.to_s == "joined"
    else
      val = false
    end
    val = true if group.user_id == self.id
    return val
  end

  def full_name
    "#{first_name} #{last_name}".titleize
  end

  def get_users_feedbacks
    Feedback.where(item_id: items.ids)
  end

  def get_my_feedbacks
    Feedback.where(user_id: id)
  end

  def has_item_feedback(item)
    feedbacks.pluck(:item_id).include?(item.id)
  end

  def get_balance
    self.balance.truncate(2).to_s(:currency)
  end

  def item_bids(item_id)
    bids.where(item_id: item_id)
  end

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver_now
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

end
