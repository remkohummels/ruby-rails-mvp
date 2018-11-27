class FollowMailer < ApplicationMailer
  add_template_helper ApplicationHelper

  def update_item_price(item, price, recipients)
    @item = item
    @price = price
    recipients.each do |recipient|
      @recipient = recipient
      @currency = recipient.currency
      mail :to => recipient.email, :subject => "[Groupnshop.com] #{@item.title} price changed."
    end
  end

  def item_bought(item, winner)
    @item = item
    @winner = User.find(winner)
    @owner = item.user
    mail :to => @owner.email, :subject => "[Groupnshop.com] #{@item.title} bought."
  end

  def item_offer_accepted(item, winner)
    @item = item
    @winner = User.find(winner)
    @owner = item.user
    mail :to => @winner.email, :subject => "[Groupnshop.com] #{@item.title} Offer accepted."
  end

  def item_closed(item, emails)
    @item = item
    @emails = emails
    mail :to => emails, :subject => "[Groupnshop.com] #{@item.title} closed."
  end
end
