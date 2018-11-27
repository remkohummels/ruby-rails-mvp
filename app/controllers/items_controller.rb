class ItemsController < ApplicationController

  before_filter :get_item, only: [:show, :update, :edit, :destroy, :buy_now, :activate_payment]
  before_filter :get_groups, only: [:edit, :new]
  before_filter :set_temp_key, :only => [:new, :edit]
  before_filter :authenticate_user!, only: [:new, :update, :edit, :destroy]
  load_and_authorize_resource param_method: :add_params
  impressionist actions: [:show], unique: [:impressionable_id, :session_hash]
  skip_before_filter :verify_authenticity_token, :only => [:save_to_draft]

  def index
    limit = params[:limit] || 10
    # get id of current category and all children
    if params[:category]
      @category = Category.find(params[:category])
      category_ids = @category.get_current_and_chield_ids
      @q = Item.includes(:bids, :user, :transactions, :images).page(params[:page]).where(category_id: category_ids).per(limit).ransack(params[:q])
    else
      @q = Item.includes(:bids, :user, :transactions, :images).page(params[:page]).per(limit).ransack(params[:q])
    end
    @items = @q.result(distinct: true)
  end

  def choose_type
    pending_items = current_user.items.pendings if current_user
    if !pending_items.blank?
      pending_item = pending_items.first
      flash[:notice] = 'You have an incomplete item. Edit or post it.'
      redirect_to item_path(pending_item)
    end
  end

  def category
  end

  def new
    @posting_type = params[:type]
    if params[:type] && params[:type] == 'quick'
      @posting_type = :quick_post
    elsif params[:type] && params[:type] == 'group'
      @posting_type = :group_post
    else
      @posting_type = :rent_post
    end

    pending_items = current_user.items.pendings
    if !pending_items.blank?
      pending_item = pending_items.first
      flash[:notice] = 'You have an incomplete item. Edit or post it.'
      redirect_to item_path(pending_item)
    else
      @item = Item.new
      @groups = current_user.joined_groups

      geo_location = get_geo_location
      @location = geo_location['city'] + ' | ' + geo_location['region'] if !geo_location['city'].blank? && !geo_location['region'].blank?
      if @location.blank?
        if current_user && !current_user.state.blank? && !current_user.city.blank?
          @location = current_user.city + ' | ' + current_user.state
        else
          @location = 'City | PROVINCE'
        end
      end
    end
  end

  def publish
    if @item.user == current_user
      @item = Item.find params[:id]
      @item.active!
      @item.end_date = DateTime.now + 48.hours
      if @item.save
        flash[:notice] = 'Item successfully published.'
        redirect_to item_path(@item)
      else
        flash[:error] = 'You need to complete an item before publishing.'
        redirect_to edit_item_path(@item)
      end
    else
      redirect_to new_item_path
    end
  end

  def save_to_draft
    if params[:id].blank?
      @item = current_user.items.new add_params
    else
      @item = Item.find params[:id]
      if @item.user == current_user && @item.pending?
        @item.assign_attributes(add_params)
      end
    end
    @item.start_price = @item.start_price / current_user.currency.course if @item.start_price
    @item.buy_now_price = @item.buy_now_price / current_user.currency.course if @item.buy_now_price
    respond_to do |format|
      if @item.save(:validate => false)
        notice = 'Your item saved to draft.'
      else
        error = "Your item not saved."
      end
      format.js{ 
        flash[:error] = error if error
        flash[:notice] = notice if notice
      }
    end
  end

  def create
    @item = current_user.items.new add_params
    @item.start_price = @item.start_price / current_user.currency.course if @item.start_price
    @item.buy_now_price = @item.buy_now_price / current_user.currency.course if @item.buy_now_price
    @item.service = @item.service / current_user.currency.course if @item.service
    @item.hourly_rate = @item.hourly_rate / current_user.currency.course if @item.hourly_rate
    @item.daily_rate = @item.daily_rate / current_user.currency.course if @item.daily_rate
    @item.weekly_rate = @item.weekly_rate / current_user.currency.course if @item.weekly_rate
    @item.hold_amount = @item.weekly_rate / current_user.currency.course if @item.hold_amount
    # unless @item.free_item.to_i.zero?
    #   @item.status = 'active'
    # end
    @item.activate_amount = 100 # TODO: amount
    respond_to do |format|
      if @item.save
        if !@item.user_in_group(current_user) && @item.group_post?
          rel = current_user.group_memberships.find_by(group_id: @item.groups.first.id)
          rel.active!
        end
        format.json {
          render json: {
              location: item_path(@item)
          }, status: 200
        }
      else
        format.js { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @user = current_user
    if @user && !@user.is_joined_groups?(@item.groups) && @user.is_blocked_groups?(@item.groups)
      flash[:error] = "You are blocked for the item's group"
      redirect_to root_path
    end
    
    if @item.user_in_group(@user) || @item.user == @user || @item.quick_post?
      @q = Item.ransack(params[:q])
    end
  end

  def edit
    @posting_type = @item.posting_type
    @groups = current_user.joined_groups

    geo_location = get_geo_location
    @location = geo_location['city'] + ' | ' + geo_location['region'] if !geo_location['city'].blank? && !geo_location['region'].blank?
    if @location.blank?
      if current_user && !current_user.state.blank? && !current_user.city.blank?
        @location = current_user.city + ' | ' + current_user.state
      else
        @location = 'City | PROVINCE'
      end
    end
  end

  def update
    @item.assign_attributes(add_params)
    @item.start_price = @item.start_price / current_user.currency.course if @item.start_price
    @item.buy_now_price = @item.buy_now_price / current_user.currency.course if @item.buy_now_price
    respond_to do |format|
      if @item.save
        format.json {
          render json: {
              location: item_path(@item)
          }, status: 200
        }
      else
        format.js { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  def finish_item
    @item = Item.find params[:id]
    @item.finish!
    respond_to do |format|
      format.json{ render json: @item, status: 200}
    end
  end

  def destroy
    @item.destroy
    redirect_to root_path
  end

  def search
    limit = params[:limit] || 12
    if params[:q].present? && params[:q][:groups_id_eq].present?
      group_id = params[:q][:groups_id_eq]
      group = Group.find group_id
      current_user.choose_group(group)
    end
    @q = Item.includes(:bids, :user, :transactions, :images, :groups).page(params[:page]).per(limit).ransack(params[:q])
    if params[:favorites]
      @items = current_user.get_voted(Item).page(params[:page]).per(limit)
    elsif params[:following]
      @items = current_user.followed_items.page(params[:page]).per(limit)
    else
      #@items = @q.result(distinct: true)
      @items = @q.result()
    end
  end

  def choose_winner
    @item.choose_winner!
    redirect_to @item
  end

  def make_an_offer
    @item = Item.find params[:id]
    @user = current_user
    if @item.bids.where(user: @user).present?
      flash[:notice] = 'You have already made an offer'
    else
      bid_price = params['bid']['price'] if params['bid'].present?
      if @item.present? && @user.present? && bid_price
        @bid = Bid.new
        @bid.user  = @user
        @bid.item  = @item
        @bid.price = bid_price.to_f / @user.currency.course
        if @bid.save
          flash[:notice] = 'Offer sent to seller'
        else
          flash[:error] = 'Enter positive value'
        end
      else
        flash[:error] = 'You cant offer this item'
      end
    end
    redirect_to :back
  end

  def set_winner
    bid = Bid.find params[:bid_id]
    if bid
      @item.set_winner(bid.user_id, bid.price)
      flash[:notice] = 'This item sold to ' + bid.user.full_name
    else
      flash[:error] = 'Something went wrong, try again.'
    end
    redirect_to :back
    
  end

  def buy_now
    if @item.user == current_user
      redirect_to :back
      flash[:error] = "You can't buy your item."
    else
      buy_now_price = params[:price]
      attrs = {
          start_price: buy_now_price,
          end_date: DateTime.now,
          winner_id: current_user.id,
          orders_count: 1,
          status: 'finished'
      }
      if @item.update_attributes(attrs)
        @item.liked_by current_user
        redirect_to @item
      end
    end
  end

  def buy_free
    if @item.user == current_user
      redirect_to :back
      flash[:error] = "You can't buy your item."
    else
      buy_free_price = params[:price]
      attrs = {
          start_price: buy_free_price,
          end_date: DateTime.now,
          orders_count: 1,
          winner_id: current_user.id,
          status: 'finished'
      }
      if @item.update_attributes(attrs)
        @item.liked_by current_user
        redirect_to @item
      end
    end
  end

  def buy_item
    @item.update_attributes stripe_params.merge(customer_ip: current_user.current_sign_in_ip.to_s)
    @item.buy_item_payment
    flash[:stripe] = 'Payment has been successfully completed.'
    redirect_to @item
  end

  def activate_payment
    @item.update_attributes stripe_params.merge(customer_ip: current_user.current_sign_in_ip.to_s)
    @item.activate_payment
    flash[:stripe] = 'You are succesfully activated item.'
    redirect_to @item
  end

  def premium_payment
    @item.update_attributes stripe_params.merge(customer_ip: current_user.current_sign_in_ip.to_s)
    @item.premium_payment
    flash[:stripe] = 'Item Premium now!'
    redirect_to @item
  end

  def similar_items

  end

  private
  def set_temp_key
    o = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
    @temp_key = (0...50).map { o[rand(o.length)] }.join
  end

  def add_params
    params.require(:item).permit(:title, :description, :category_id, :condition, :buy_now_price, :reverse_price, :start_price, :keywords, :temp_key, :posting_type, :website, :free_item, :pickup, :group_id, :location, :groups, :availability, :rent_item_location, :rent_item_condition, :instruction, :service, :hourly_rate, :daily_rate, :weekly_rate, :hold_amount, :accept_term, group_ids: [])
  end

  def stripe_params
    params.require(:item).permit(:stripeEmail, :stripeToken)
  end

  def get_item
    @item = Item.includes(:bids, :user, :transactions, :images).find(params[:id])
  end

  def get_groups
    if current_user
      @groups = current_user.groups
    end
  end
end
