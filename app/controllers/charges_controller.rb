class ChargesController < ApplicationController

  rescue_from Stripe::CardError, with: :catch_exception

  def new
    @item = Item.find_by(id: params[:item_id])
    @charge_amount = params[:charge_amount]
  end

  def create
    StripeChargesServices.new(charges_params, current_user, @item, @charge_amount).call
    redirect_to new_charge_path
  end

  private

  def charges_params
    params.permit(:stripeEmail, :stripeToken)
  end

  def catch_exception(exception)
    flash[:error] = exception.message
  end

end
