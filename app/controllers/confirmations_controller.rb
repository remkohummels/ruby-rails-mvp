class ConfirmationsController < Devise::ConfirmationsController
  protected

  def after_confirmation_path_for(resource_name, resource)
    flash.clear
    flash[:notice] = 'Your email address has been successfully confirmed. Now you can sign in.'
    root_path(anchor: 'sign_section')
  end
end