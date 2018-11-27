class GroupsController < ApplicationController

  before_filter :authenticate_user!, except: [:index]
  load_and_authorize_resource param_method: :group_params
  before_filter :get_group, only: [:show, :update, :edit, :destroy, :block_user, :unblock_user]
  before_filter :get_user, only: [:block_user, :unblock_user]
  before_filter :search, only: [:index]

  def index 
    if @groups.blank? || @location.blank?
      if current_user
        country = current_user.country if current_user.country.present?
        state   = current_user.state if current_user.state.present?
        city    = current_user.city if current_user.city.present?
      else
        geo_location = get_geo_location
        country = geo_location['country']
        state   = geo_location['region']
        city    = geo_location['city']
      end

      @location = ''
      @groups = Group.actives if @groups.nil?
      @groups = @groups.where(country: country) unless country.blank?

      unless state.blank?
        @groups = @groups.where(state: state)
        @location = state.upcase
      end

      unless city.blank?
        if @groups.where(city: city).present?
          @groups = @groups.where(city: city)
          @location = ' | ' + @location unless @location.blank?
          @location = city.capitalize + @location
        end
      end

      @location = 'WorldWide' if @location.blank?
    end
  end

  def new
  end

  def create
    @group = current_user.groups.build group_params
    respond_to do |format|
      if @group.valid? && params[:check]
        @group.save
        format.json {
          render json: {
              location: group_path(@group)
          }, status: 200
        }
      else
        @group.errors.add :check, "You should agree the terms and conditions of groupnshop." if params[:check].blank?
        format.js { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @items = @group.items.active.latest_items.limit(3)
  end

  def switch
    @groups = current_user.joined_groups
  end

  def edit
  end

  def update
    respond_to do |format|
      if @group.update_attributes(group_params)
        format.json {
          render json: {
              location: group_path(@group)
          }, status: 200
        }
      else
        format.js { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @group.destroy
    redirect_to groups_path
  end

  def search
    if params[:q]
      @gq = Group.includes(:items, :memberships).page(params[:page]).ransack(params[:q])
      @groups = @gq.result()
      @location = params[:q][:city_or_state_cont]
    end
  end

  def invite_to_group
    group = Group.find params[:group_id]
    user = current_user
    emails = params[:email].split(',')
    sended = ''
    invalid = ''
    emails.each do |email|
      email = email.downcase.delete(' ')
      if email.count("@") != 1
        if invalid.blank?
          invalid += email
        else
          invalid += ', ' + email
        end
      elsif email =~ /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
        if sended.blank?
          sended += email 
        else
          sended += ', ' + email
        end
      else
        if invalid.blank?
          invalid += email
        else
          invalid += ', ' + email
        end
      end
    end
    if !sended.blank?
      flash[:success] = 'Invite sent to ' + sended +'.'
      sended = sended.split(',')
      GroupMailer.invite_to_group(user, sended, group).deliver
    end
    if !invalid.blank?
      flash[:error] = '"' + invalid + '"' + ' is not valid.'
    end
    redirect_to :back
  end

  def add_to_group
    @user = User.find_by_id params[:user_id]
    @group = Group.find_by_id params[:group_id]
    if @user && @group
      group_memberships = @user.group_memberships.where(group_id: @group.id)
      if !group_memberships.blank?
        group_memberships = group_memberships.first
        if group_memberships.update status: 'joined'
          respond_to do |format|
            format.js
          end
        end
      end 
    end
  end

  def remove_from_group
    @user = User.find_by_id params[:user_id]
    @group = Group.find_by_id params[:group_id]
    if @user && @group
      group_memberships = @user.group_memberships.where(group_id: @group.id)
      if !group_memberships.blank?
        group_memberships = group_memberships.first
        if group_memberships.delete
          respond_to do |format|
            format.js
          end
        end
      end
    end
  end

  def appoint_admin
    @user = User.find_by_id params[:user_id]
    @group = Group.find_by_id params[:group_id]
    if @user && @group
      @group.provide_to_admin(@user)
    end
    flash[:notice] = @user.full_name + ' is admin now.'
    redirect_to :back
  end

  def demote_user
    @user = User.find_by_id params[:user_id]
    @group = Group.find_by_id params[:group_id]
    if @user && @group
      @group.demote_to_user(@user)
    end
    flash[:notice] = @user.full_name + ' is no longer admin.'
    redirect_to :back
  end

  def leave_group
    @group = Group.find_by_id params[:group_id]
    if @group
      group_memberships = @group.group_memberships.where(user_id: current_user.id)
      if !group_memberships.blank?
        group_memberships = group_memberships.first
        group_memberships.delete
        respond_to do |format|
          format.js
        end
      end
    end
  end

  def join_group
    @group = Group.find_by_id params[:group_id]
    if @group
      current_user.group_memberships.create group_id: @group.id
      respond_to do |format|
        format.js{ flash[:notice] = "An email will be sent to you when your request to join #{ActionController::Base.helpers.link_to @group.title, group_url(@group) } is approved." }
      end
    end
  end

  def choose_group
    @group = Group.find_by_id params[:group_id]
    if @group
      rel = current_user.group_memberships.find_by(group_id: @group.id)
      rel.active!
    end
    redirect_to group_path(@group)
  end

  def switch_group
    @group = Group.find_by_id params[:group_id]
    if @group
      rel = current_user.group_memberships.find_by(group_id: @group.id)
      rel.not_active!
      rel.save
    end
    redirect_to group_path(@group)
  end

  def load_more
    @group = Group.find params[:group_id]
    @items = @group.items.active
    last_id = params[:item_id].to_i
    if last_id
      @items = @items.where('items.id < ?', last_id).latest_items.limit(3)
      items_html = ''
      counter = 0
      @items.each do |item|
        # counter+=1
        # delay = counter.to_f/20
        items_html += render_to_string :layout => false, :template => 'partials/_new_bid', :locals => {:item => item}
      end
      next_items = @group.items.active.where(id: last_id - 4).present?
    end
    # binding.pry
    respond_to do |format|
      format.json {render json: { html: items_html, next_items: next_items, status: "success"}}
    end
  end

  def block_user
    if @group.block_user(@user, current_user)
      BlockReason.create(user: @user, group: @group, reason: params[:reason])
    else
      flash[:error] = "You can't block this user!"
    end
    redirect_to group_user_path(@group, @user)
  end

  def unblock_user
    if !@group.unblock_user(@user, current_user)
      flash[:error] = "You can't unblock this user!"
    end
    redirect_to group_user_path(@group, @user)
  end


  private
  def group_params
    params.require(:group).permit(:title, :description, :rules, :terms, :file, :banner)
  end

  def get_group
    @group = Group.find(params[:id])
  end

  def get_user
    @user = User.find_by(id: params[:user_id])
    redirect_to group_path(@group) if @user.nil?
  end

end
