class MainController < ApplicationController
  def index
    @limit = Item::ITEMS_LIMIT
    @categories = Category.ordered_list
    @groups = Group.sort_by_popularity.first(@limit)
    @items = Item.active
    #@items += current_user.winned_items.where.not(status: 'paid') if current_user.winned_items
    @hottests = Item.all.sort_by {|item| item.hot_rate }.reverse.take(@limit)
    @head_category = Category.where(parent_id: nil)
    # render layout: nil
  end

  def how_it_works
  end

  def faqs
  end

  def prohibited_items
  end

  def terms_of_use
    @no_tab = !!params[:no_layout]
    render layout: nil if params[:no_layout]
  end

  def privacy_policy
  end
end

