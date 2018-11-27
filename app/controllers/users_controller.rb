class UsersController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :get_q, only: [:edit, :dashboard, :feedbacks, :transactions]
  load_and_authorize_resource param_method: :add_params, except: [:set_currency]
  before_filter :authenticate_user!, except: [:block]
  before_action :update_location, only: [:edit, :transactions, :settings, :set_currency, :new_password, :show, :following]

  def index
  end

  def show
    @group = Group.find_by(id: params[:group_id])
    @user = get_user
  end

  def edit
    @user = User.find(params[:id])
  end

  def transactions
    @messages = current_user.received_messages
    @bids = current_user.bids
  end

  def security
    @user = current_user
  end

  def settings
    @user = current_user
    @notification_permit = @user.notification_permit
  end

  def set_notification_permit
    @notification_permit = current_user.notification_permit
    @notification_permit.update_attributes( notification_permit_params )
    redirect_to settings_path
  end

  def set_currency
    @currency = Currency.find(params[:title])
    current_user.currency = @currency
    @result = current_user.save
  end

  def update
    account = (params['user']['account'] == 'true')
    user_params = add_params
    if account && (params['user']['password'].empty? || params['user']['password_confirmation'].empty?)
      user_params = add_params.except(:password, :password_confirmation)
    end
    @user = User.find(params[:id])
    respond_to do |format|
      if !params[:user][:old_password].empty? and @user.valid_password?(params[:user][:old_password])
        if @user.update_attributes(user_params)
          format.json do
            render json: {
                location: account_dashboard_path
            }, status: 200
          end
        else
          format.js { render json: @user.errors, status: :unprocessable_entity }
        end
      else
        format.js { render json: {"old_password" => ["Incorrect Password"]}, status: :unprocessable_entity }
      end
    end
  end

  def following
    @title = "Following Items"
    @user = User.find(params[:id])
    @items = @user.followed_items.page(params[:page]).per(10)
    render 'show_follow'
  end

  def new_password
    @user = current_user
  end

  def update_password
    @user = User.find(current_user.id)
    sign_in @user, bypass: true if @user.update_with_password(add_params)
    redirect_to(root_path) && return
  end

  def dashboard
  end

  def bids
    @user = get_user
  end

  private

  def update_location
    if (current_user.updated_at < Time.now - 5.hours) || current_user.country.blank? || current_user.city.blank?
      geo_location = get_geo_location
      current_user.country = geo_location['country']
      current_user.state   = geo_location['region']
      current_user.city    = geo_location['city']
      current_user.save
    end
  end

  def get_q
    @q = Item.ransack(params[:q])
  end

  def get_user
    if !params[:id]
      current_user
    else
      User.find(params[:id])
    end
  end

  def add_params
    params.require(:user).permit(:password, :password_confirmation, :current_password, :first_name, :last_name, :website, :phone, :country, :city, :community, :about, :referral, :currency_id, :avatar_url)
  end

  def notification_permit_params
    params.require(:notification_permit).permit(:change_item, :win_item, :close_item)
  end
end
