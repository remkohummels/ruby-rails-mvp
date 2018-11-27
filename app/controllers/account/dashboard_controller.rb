 class Account::DashboardController < AccountBaseController
  def index
    @reports_items = Item.finisheds.where("user_id = ? OR winner_id = ?", current_user.id, current_user.id)

    weather = WeatherService.new
    geo_location = get_geo_location
    coordinate = geo_location['loc'].to_s.split(',')
    @weather = weather.get(coordinate[0], coordinate[1])

    @rating_groups = Group.joins(:group_memberships).group("groups.id").order("count(group_memberships.id) DESC").limit(5)
    @closing_items = Item.active.where(posting_type: :group_post).where("end_date < ?", Time.now+3.hours).joins(:bids).where(bids:{user_id: current_user.id}).distinct
    @group_admins = Group.joins(:group_memberships).where(group_memberships: {user: current_user, status: :joined, role: :admin})
  end
  def items
    @user = current_user
    @items = @user.items
  end

  def feedbacks
    @user = current_user
  end

  def bids
    @bids = current_user.bids.joins(:item).where(items:{status: :active})
  end
end
