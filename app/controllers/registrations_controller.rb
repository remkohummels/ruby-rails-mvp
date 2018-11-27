class RegistrationsController < Devise::RegistrationsController
  skip_before_filter :verify_authenticity_token

  def sign_up_params
    devise_parameter_sanitizer.sanitize(:sign_up)
    params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name, :referral)
  end
  protected

  def after_inactive_sign_up_path_for(resource)
    flash.clear
    flash[:notice] = 'Please activate your account by clicking on the link sent to your email.'
    root_path(anchor: 'sign_section')
  end

  def after_sign_up_path_for(user)
    root_path(anchor: 'sign_section')
  end

  def update_resource(resource, params)
    resource.update_without_password(params)
  end
end
