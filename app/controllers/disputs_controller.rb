class DisputsController < ApplicationController

  before_filter :authenticate_user!
  load_and_authorize_resource param_method: :disput_params

  def index
    @disputs = Disput.includes(:comments, :item, :user).ransack(params[:q]).result()
    @disputs = Disput.includes(:comments, :item, :user).all if params[:admin] == 'true'
  end

  def show
    @disput = Disput.find params[:id]
  end

  def create
    @disput = current_user.disputs.build disput_params
    respond_to do |format|
      if @disput.save
        DisputMailer.open_disput(@disput.item.user, @disput).deliver_now
        format.json {
          render json: {
            location: disput_path(@disput)
          }, status: 200
        }
      else
        format.js { render json: @disput.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @disput = Disput.find params[:id]
    respond_to do |format|
      if @disput.update disput_params
         @disput.update status: 'resolved'
        format.json {
          render json: {
            location: disput_path(@disput)
          }, status: 200
        }
      else
        format.js { render json: @disput.errors, status: :unprocessable_entity }
      end
    end
  end

  def delete
  end

  def edit
  end

  def open_disput_modal
    @disput = Disput.new item_id: params[:item_id]
    respond_to do |format|
      format.html {render('open_disput_modal', layout: false)}
      format.json {render json: { html: render_to_string('open_disput_modal', layout: false)}, status: 200 }
    end
  end

  def resolve_disput_modal
    @disput = Disput.find params[:disput_id]
    respond_to do |format|
      format.html {render('resolve_disput_modal', layout: false)}
      format.json {render json: { html: render_to_string('resolve_disput_modal', layout: false)}, status: 200 }
    end
  end
  private
    def disput_params
      params.require(:disput).permit(:reason, :description, :item_id, :user_id, :resolve_reason, :winner_id)
    end
end
