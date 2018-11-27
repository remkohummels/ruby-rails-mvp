class FeedbacksController < ApplicationController
  before_filter :get_item
  before_filter :authenticate_user!, only: [:new, :update, :edit, :destroy]
  load_and_authorize_resource param_method: :feed_params

  def create
    if @item
      @feed = current_user.feedbacks.build feed_params
      respond_to do |format|
        if @feed.valid? && @feed.save
          format.json do
            render json: {
                location: item_path(@item)
            }, status: 200
          end
        else
          format.js { render json: @feed.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to root_path
    end
  end

  def new
    @q = Item.ransack(params[:q])
  end

  private

  def get_item
    @item = Item.find(feed_params['item_id'])
  end

  def feed_params
    params.require(:feedback).permit(:item_id, :title, :text)
  end
end
