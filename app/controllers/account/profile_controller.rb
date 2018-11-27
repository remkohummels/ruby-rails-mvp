class Account::ProfileController < AccountBaseController
  def index
  end
  def edit
    @user = current_user
  end
  def update
    account = (params['user']['account'] == 'true')
    user_params = add_params
    if account && (params['user']['password'].empty? || params['user']['password_confirmation'].empty?)
      user_params = add_params.except(:password, :password_confirmation)
    end
    @user = current_user
    if @user.update_attributes(user_params)
      sign_in(@user, bypass: true)
      render :edit
    else
      flash[:error] = @user.errors
      render :edit
    end
  end
  def profile
    @user = current_user
    render 'show'
  end

  def new_password
    @user = current_user
  end

  def update_password
    @user = User.find(current_user.id)
    sign_in @user, bypass: true if @user.update_with_password(add_params)
    redirect_to(root_path) && return
  end

  def dashboard
  end

  def feedbacks
    @user = current_user
  end

  def bids
    @user = current_user
  end

private
  def add_params
      params.require(:user).permit(:password, :password_confirmation, :current_password, :first_name, :last_name, :website, :phone, :country, :city, :community, :about, :referral, :currency_id, :avatar_url)
    end
end