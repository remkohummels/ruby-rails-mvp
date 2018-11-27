class ImagesController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def show

  end

  def index
    @item = Item.includes(:images).find_by_id params[:item_id]
    respond_to do |format|
      format.html {render('index', layout: false)}
      format.json {render json: { html: render_to_string('index', layout: false)}, status: 200 }
    end
  end

  def create
    @file = Image.new ({
        temp_key: params['temp_key'],
        file: params['file']
      }
    )
    @file.save!
    render json: @file
  end

  def destroy
    if params[:temp_key]
      @image = Image.where( temp_key: params[:temp_key] )
      @image = @image.find params[:id]
    else
      @image = Image.find(params[:id])
    end
    @image.destroy
    render json: @image
  end

  private
  def photo_params
    params.require(:image).permit(:file)
  end
end
