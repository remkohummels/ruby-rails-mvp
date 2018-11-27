class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_filter :set_global_search_variable
  before_filter :set_referal
  before_filter :set_global_var
  # before_filter :set_geo_location

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

    def set_global_var
      @inbox_msg_count = current_user.received_messages.unread.count if current_user

      if current_user
        @currency = current_user.currency
      else
        # @currency = Currency.get_by_country(@geo_location['country_code'])
        @currency = Currency.get_by_country('USD')
      end
    end

    def get_geo_location
      print "Request ID=#{request.remote_ip}"
      geo = GeoIpService.new(ip: request.remote_ip)
      geo.get_location
    end
end