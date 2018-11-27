class AccountBaseController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_var
  layout 'account'

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path(anchor: 'sign_section'), :alert => exception.message
  end

  def set_global_search_variable
    return @q if @q
    @q = Item.search(params[:q])
    @gq = Group.search(params[:q])
  end

  def categories
    return @categories if @categories
    @categories = Category.ordered_list
  end
  private
  def set_referal
    session[:referral] = params[:referral] if params[:referral]
  end
  def set_var
    
  end
end