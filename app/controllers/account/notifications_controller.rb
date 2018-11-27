class Account::NotificationsController < AccountBaseController
  before_action :get_notification, only: [:destroy]
  after_action  :update_new_notifications, only: [:index]

  def index
    @notifications = current_user.notifications.order('created_at DESC')
  end

  def destroy
    @notification.destroy
    render layout: false
  end

  private

  def get_notification
    @notification = Notification.find(params[:id])
  end

  def update_new_notifications
    @notifications.update_all(is_new: false)
  end
end
