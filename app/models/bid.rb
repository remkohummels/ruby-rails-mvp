# == Schema Information
#
# Table name: bids
#
#  id         :integer          not null, primary key
#  price      :float
#  user_id    :integer
#  item_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Bid < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  STEP = 0.5
  belongs_to :user
  belongs_to :item, counter_cache: true
  validates :user, presence: true
  validates :item, presence: true
  validates :price, presence: true
  # validates_numericality_of :price, :only_integer => true, :greater_than_or_equal_to => 1
  validates_numericality_of :price, :greater_than_or_equal_to => 1
  validate :min_bid, if: 'self.price && self.item.group_post?'
  # validate :max_bid, if: 'self.price'
  validate :self_bid

  scope :date_desc, -> {order('created_at desc')}

  after_create :follow_item
  after_destroy :send_destroy_notification
  after_create :send_create_notification


  def self_bid
    if self.item.user.id == self.user_id
      errors.add(:price, "You cannot bid on your own item")
    end
  end

  def follow_item
    user = self.user
    item = self.item
    if !user.following?(item)
      user.follow!(item)
    end
  end

  # def max_bid
  #   max_bid =  self.user.balance
  #   if self.price  > max_bid
  #     errors.add(:price, "Your bid greater then your balance")
  #   end
  # end

  def min_bid
    next_bid = self.item.start_price + Bid::STEP
    if self.price < next_bid
      errors.add(:price, "Bid has to be higher than the current price.")
    end
  end

  private

  def send_create_notification
    if self.item.posting_type.to_s == 'quick_post'
      price = self.item.user.currency.convert(self.price)
      self.item.user.notifications.create(content: "<a href='#{user_path(self.user)}'>#{self.user.full_name}</a> has made an offer of #{price} on <a href='#{item_path(self.item)}'>#{self.item.title}</a>.")
    end
  end

  def send_destroy_notification
    if Bid.where(item: self.item, user: self.user).empty?
      self.user.notifications.create(content: "The item you are interested has been removed by the Group Admins.")
    end
  end
end
