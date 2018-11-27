class FaqItemsController < ApplicationController

  def index
    @faqitems = FaqItem.all
  end

  def new
    @faqitem = FaqItem.new
  end

  def create
    @faqitem = FaqItem.create(item_params)
  end

  def update
    @faqitem = FaqItem.find(params[:id])
    @faqitem.update_attributes(item_params)

  end

  def destroy
    @faqitem.destroy
  end


  private

    def item_params
      params.require(:faqitem).permit(:question, :answer)
    end
end
