class BidsController < ApplicationController

  before_filter :authenticate_user!
  skip_before_filter :verify_authenticity_token
  load_and_authorize_resource

  def create
    @item = Item.find(bid_params['item_id'])
    if @item
      @bid = current_user.bids.new bid_params
      @bid.price = @bid.price / current_user.currency.course
      @bid.save
      respond_to do |format|
        if @bid.valid?
          @item.start_price = @bid.price
          if @bid.save && @item.save
            format.json {
              render json: {
                  location: item_path(@item)
              }, status: 200
            }
          end
        else
          format.js { render json: @bid.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  private
  def bid_params
    params.require(:bid).permit(:item_id, :price)
  end
end
