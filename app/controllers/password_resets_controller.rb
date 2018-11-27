class PasswordResetsController < ApplicationController
  def create
    user = User.find_by_email(params[:email])
    user.send_password_reset if user
    redirect_to root_path(anchor: 'sign_section'), :notice => "Password reset instructions sent to your email."
  end

  def edit
    @user = User.find_by_password_reset_token!(params[:id])
  end

  def update
    @user = User.find_by_password_reset_token!(params[:id])
    if @user.password_reset_sent_at < 2.hours.ago
      redirect_to root_path(anchor: 'sign_section'), :alert => "Password reset has expired."
    elsif @user.update_attributes user_params
      redirect_to root_path(anchor: 'sign_section'), :notice => "Password has been reset!"
    else
      render :edit
    end
  end
  private
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end
end
