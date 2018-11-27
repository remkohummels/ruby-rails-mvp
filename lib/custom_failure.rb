class CustomFailure < Devise::FailureApp
  def redirect_url
    #binding.pry
    if scope == :admin_user
      new_admin_user_session_path
    else
      if warden_message == :unconfirmed
        flash.clear
        flash[:error] = 'Please activate your account by clicking on the link sent to your email.'
        root_path(anchor: 'sign_section')
      elsif warden_message == :not_found_in_database
        flash.clear
        flash[:error] = 'Email not registered. <a href="/users/sign_up">Click here </a>to register.'
        root_path(anchor: 'sign_section')
      elsif warden_message == :invalid
        flash.clear
        flash[:error] = 'Invalid email or password. <a href="/password_resets/new"> Forgot password? </a>'
        root_path(anchor: 'sign_section')
      else
        root_path(anchor: 'sign_section')
      end
    end
  end

  # You need to override respond to eliminate recall

  def respond
    if http_auth?
      http_auth 
    else
      redirect
    end
  end

end