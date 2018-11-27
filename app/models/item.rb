# == Schema Information
#
# Table name: items
#
#  id                  :integer          not null, primary key
#  title               :string
#  description         :string
#  start_price         :float
#  reverse_price       :float
#  condition           :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  keywords            :string
#  user_id             :integer
#  buy_now_price       :float
#  shipping_price      :float
#  bids_count          :integer          default(0)
#  end_date            :datetime
#  winner_id           :integer
#  category_id         :integer
#  status              :string           default("pending")
#  activate_amount     :integer
#  views_counter       :integer          default(0)
#  premium_expiry_date :datetime
#  images_count        :integer          default(0)
#  website             :string
#  free_item           :string           default("0")
#  pickup              :string
#  group_id            :integer
#  orders_count        :integer
#  location            :string
#  posting_type        :string
# availability :string
# rent_item_location :string
# rent_item_condition :string
# instruction :string
# service :float DEFAULT 0.0,
# hourly_rate :float  DEFAULT 0.0,
# daily_rate :float  DEFAULT 0.0,
# weekly_rate :float  DEFAULT 0.0,
# hold_amount :float  DEFAULT 0.0,
# accept_term :boolean DEFAULT false,

class Item < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  ITEMS_LIMIT = 12

  PREMIUM_AMOUNT = 11
  PREMIUM_DATE = 7

  PREMIUM_IMAGES_COUNT = 10
  REGULAR_IMAGES_COUNT = 7

  belongs_to :user
  belongs_to :category 
  # belongs_to :winner, foreign_key: 'winner_id', class_name: 'User'
  has_many :item_group_relations, dependent: :destroy
  has_many :groups, through: :item_group_relations

  has_many :images, dependent: :destroy
  has_many :feedbacks
  has_many :bids, dependent: :destroy
  has_many :transactions
  has_many :disputs

  has_many :reverse_relationships, foreign_key: "followed_id", class_name:  "Relationship", dependent: :destroy
  has_many :followers, through: :reverse_relationships, source: :follower

  has_one :rating, class_name: 'RatingCache', foreign_key: 'cacheable_id'
  delegate :avg, to: :rating, allow_nil: true

  validates :user, presence: true
  validates :title, presence: true
  validates :start_price, presence: {message: "Must be a number"}, :numericality => { :greater_than => 0, message: "Must be a number"}, if: '!self.is_free? && self.group_post?'
  # validates :buy_now_price, :numericality => { :greater_than => 0}, if: '!self.is_free?'
  validates :description, presence: true, length: {minimum: 20}
  validates :groups, :presence => true, if: 'self.group_post?'
  validate :item_images_presence
  # validate :image_counts, if: 'self.is_premium'
  validates :availability, :presence => true, if: 'self.rent_post?'
  validates :rent_item_location, :presence => true, if: 'self.rent_post?'
  validates :rent_item_condition, :presence => true, length: {maximum: 10}, if: 'self.rent_post?'
  validates :service, :presence => true, :numericality => { :greater_than => 0, message: "Must be a number"}, if: 'self.rent_post?'
  # validates :hourly_rate, :presence => true, :numericality => { :greater_than => 0, message: "Must be a number"}, if: 'self.rent_post?'
  validates :daily_rate, :presence => true, :numericality => { :greater_than => 0, message: "Must be a number"}, if: 'self.rent_post?'
  validates :weekly_rate, :presence => true, :numericality => { :greater_than => 0, message: "Must be a number"}, if: 'self.rent_post?'
  validates :hold_amount, :presence => true, :numericality => { :greater_than => 0, message: "Must be a number"}, if: 'self.rent_post?'
  validates :accept_term, :acceptance => {:accept => true}, if: 'self.rent_post?'

  after_save :bind_photos
  after_save :send_notification
  before_save :set_default_end_time

  attr_accessor :temp_key
  attr_accessor :stripeEmail
  attr_accessor :stripeToken
  attr_accessor :customer_ip

  scope :active, -> { actives.where("posting_type != ? OR end_date > ?", :group_post, Time.now) }
  scope :premium, -> {
    order('premium_expiry_date ASC')
   }
  scope :limited, -> { limit ITEMS_LIMIT }
  scope :ending_soon, -> { active.order('end_date asc').limited }
  scope :latest_items, -> { order('created_at DESC').limited }
  scope :first_items, -> { order('created_at asc').limited }
  scope :by_user, -> (user){ active.where user_id: user.id }
  scope :free, -> { active.where free_item: '1'}
  default_scope { latest_items }

  as_enum :condition, [:new, :euc, :guc], source: :condition, map: :string
  as_enum :status, [:pending, :active, :finished, :paid], source: :status, map: :string
  as_enum :pickup, [:local], source: :pickup, map: :string
  as_enum :posting_type, [:group_post, :quick_post, :rent_post], source: :posting_type, map: :string
  as_enum :availability, [:available, :unavailable], source: :availability, map: :string

  acts_as_votable
  ratyrate_rateable 'rate'
  is_impressionable :counter_cache => true, :column_name => :views_counter,  unique: :all
  before_update :notify
  after_create :follow_item

  def hot_rate
    self.followers.count + self.get_likes.count
  end

  def follow_item
    user = self.user
    if !user.following?(self)
      user.follow!(self)
    end
  end

  def notify
    @followers = self.followers
    if self.start_price_changed? && !@followers.blank?
      recipients = []
      @followers.each do |user|
        if user.notification_permit.change_item
          recipients << user
        end
      end
      FollowMailer.update_item_price(self, self.start_price, recipients).deliver_later
    end
    if self.winner_id_changed? && self.winner_id && !@followers.blank?
      FollowMailer.item_offer_accepted(self, self.winner_id).deliver_later
      FollowMailer.item_bought(self, self.winner_id).deliver_later
    elsif self.status == 'finished' && !@followers.blank?
      send_list = []
      @followers.each do |user|
        if user.notification_permit.close_item
          send_list << user.email
        end
      end
      FollowMailer.item_closed(self, send_list).deliver_later
    end
  end

  # Custom Validations
  def image_counts
    if self.images_count >= self.allowed_images_count
      errors.add(:images_count, "You cannot add more attachments. Please upgrade to Premium.")
    end
  end

  def self.promo
    Item.active.where(free_item: '0').where("status = 'active' or status= 'paid'").order("RANDOM()").limit(4)
  end

  def get_avatar
    images.first.file.url(:listing) if images.first
  end
  
  def in_group?(group)
    self.groups.include? group
  end
  
  def user_in_group(user)
    state = false 
    self.groups.each do |group|
      state = state || (group && user && user.in_group?(group))
    end
    return state
  end

  def get_max_bid_user
    bids.max.try(:user)
  end

  def created_date
    created_at.strftime('%B %d, %Y %H:%I:%S')
  end

  def winner
    if end_date < DateTime.now
      if winner_id
        User.find_by_id(winner_id)
      else
        winner = get_max_bid_user
        if winner
          self.winner_id = winner.id
          self.end_date = DateTime.now
          self.status = 'finished'
          self.orders_count = 1
          winner if save
        end
      end
    end
  end

  def choose_winner!
    if winner_id
      User.find_by_id(winner_id)
    else
      winner = get_max_bid_user
      if winner
        self.winner_id = winner.id
        self.end_date = DateTime.now
        self.status = 'finished'
        self.orders_count = 1
        winner if save
      end
    end
  end

  def set_winner(user_id, price)
    self.start_price   = price
    self.buy_now_price = price
    self.winner_id     = user_id
    self.end_date      = DateTime.now
    self.status        = 'finished'
    self.orders_count  = 1
    self.save
  end

  def finish!
    self.status = 'finished'
    self.end_date = DateTime.now
    self.save
  end

  def is_premium
    self.premium_expiry_date && self.premium_expiry_date > DateTime.now
  end

  def is_free?
    !self.free_item.to_i.zero?
  end

  def allowed_images_count
      if self.is_premium
        PREMIUM_IMAGES_COUNT - self.images_count
      else
        REGULAR_IMAGES_COUNT - self.images_count
      end
  end

  def buy_item_payment
    charge = stripe_charge start_price
    if charge.paid? && charge.status.inquiry.succeeded?
      create_transactions charge, 'buy'
      user_balance = self.user.balance
      self.user.update balance: user_balance + self.start_price
      self.update status: 'paid' if self.transactions.buy.sum('amount') >= self.start_price
    end
  end

  def activate_payment
    charge = stripe_charge activate_amount
    if charge.paid? && charge.status.inquiry.succeeded?
      create_transactions charge, 'activate'
      user_balance = self.user.balance
      self.user.update balance: user_balance - activate_amount
      self.update status: 'active' if self.transactions.activate.sum('amount') >= self.activate_amount
    end
  end

  def premium_payment
    charge = stripe_charge PREMIUM_AMOUNT
    if charge.paid? && charge.status.inquiry.succeeded?
      create_transactions charge, 'premium'
      user_balance = self.user.balance
      self.user.update balance: user_balance - PREMIUM_AMOUNT
      self.update premium_expiry_date: DateTime.now + PREMIUM_DATE.days if (charge.amount / 100) >= PREMIUM_AMOUNT
    end
  end

  def create_transactions(charge, kind)
    user = User.find_by_email charge.source.name
    params = {
        customer: charge.source.customer,
        email: charge.source.name,
        status: charge.status.to_s,
        paid: charge.paid.to_s,
        customer_ip: self.customer_ip,
        amount: charge.amount / 100,
        kind: kind,
        item_id: self.id
    }
    if user
      transaction = user.transactions.build params
      transaction.save
    end
  end

  def stripe_charge(amount)
    customer = Stripe::Customer.create(
        email: self.stripeEmail,
        source: self.stripeToken
    )
    
    charge = Stripe::Charge.create(
        amount: (amount * 100).to_i,
        customer: customer.id,
        description: self.title,
        currency: 'usd'
    )

    charge

  rescue Stripe::CardError => e
    redirect_to self # TODO: доделать ошибки страйпа

  end

  private

  def item_images_presence
    images_presence = Image.where(temp_key: self.temp_key).present? || self.images.present?
    self.errors.add(:temp_key, 'Must include at least one image') if !images_presence
  end

  def set_default_end_time
    self.end_date = DateTime.now + 48.hours unless end_date
  end

  def bind_photos
    images = Image.where(temp_key: temp_key).all
    images.each do |image|
      image.item_id = id
      image.save
    end
  end

  def send_notification
    if self.changes[:winner_id] && self.winner.present? && self.posting_type.to_s == 'quick_post'
      # self.winner.notifications.create(content: "Your offer is accepted for item: <a href='<%= item_path(self) %>'>#{self.title}</a>")
      self.winner.notifications.create(content: "<a href='#{user_path(self.user)}'>#{self.user.full_name}</a> has accepted your offer for <a href='#{item_path(self)}'>#{self.title}</a>")
    end
  end
end
