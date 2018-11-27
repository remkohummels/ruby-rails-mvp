class SessionsController < Devise::SessionsController
  def sign_in_params
    devise_parameter_sanitizer.sanitize(:sign_in)
    # params.require(:user).permit(:email, :password)
  end

  # POST /resource/sign_in
  def create
    flash[:signin] = "To change currency click on the flag in the top banner"
    current_user.get_location if current_user && ((current_user.updated_at < Time.now - 5.hours) || current_user.country.blank? || current_user.city.blank?)
    super
  end

end
