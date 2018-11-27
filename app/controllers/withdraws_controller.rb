class WithdrawsController < ApplicationController
  #load_and_authorize_resource param_method: :withdraw_params

  def new
    @withdraw = Withdraw.new
  end

  def create
    @withdraw = Withdraw.new(withdraw_params.merge(user_id: current_user.id))
    respond_to do |format|
      if @withdraw.save()
        format.json do
          render json: {
              location: dashboard_path
          }, status: 200
        end
      else
        format.js { render json: @withdraw.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def withdraw_params
    params.require(:withdraw).permit(:amount, :card_number, :comment)
  end
end
