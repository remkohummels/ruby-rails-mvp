class BrowseController < ApplicationController

  def index
    @categories = Category.ordered_list
    # @items = Item.all
    limit = params[:limit] || 12
    if params[:q].present? && params[:q][:groups_id_eq].present?
      group_id = params[:q][:groups_id_eq]
      group = Group.find group_id
      current_user.choose_group(group)
    end

    @items = Item.active

    @items = @items.where(posting_type: params[:posting_type]) if params[:posting_type]

    @q = @items.includes(:bids, :user, :transactions, :images, :groups).page(params[:page]).per(limit).ransack(params[:q])
    if params[:favorites]
      @items = current_user.get_voted(Item).page(params[:page]).per(limit)
    elsif params[:following]
      @items = current_user.followed_items.active.page(params[:page]).per(limit)
    else
      #@items = @q.result(distinct: true)
      @items = @q.result()
    end
  end

  def select
    
  end

  def category
    @categories = Category.ordered_list
  end
end
 