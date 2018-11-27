class DisputCommentsController < ApplicationController

  before_filter :authenticate_user!
  load_and_authorize_resource param_method: :disput_comments_params

  def index
  end

  def create
    @comment = current_user.disput_comments.build disput_comments_params
    respond_to do |format|
      if @comment.save
        format.json {
          render json: {
            location: disput_path(@comment.disput)
          }, status: 200
        }
      else
        format.js { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end
  private
    def disput_comments_params
      params.require(:disput_comment).permit(:message, :disput_id, :user_id)
    end
end
