class MessagesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_q, only: [:index, :new]
  before_filter :get_message, only: [:destroy, :change_status]
  

  def index
    @user = current_user
  end

  def feedback
    @message = Message.new
  end

  def create
    @message = current_user.send_messages.build message_params
    messages = Message.by_sender_id_and_recipient_id(@message.recipient_id, @message.sender_id)
    if messages.present?
      if messages.last.buyer?
        @message.seller!
      end
    end
    respond_to do |format|
      if @message.save
        format.json do
          render json: {
            location: messages_path
          }, status: 200
        end
      else
        format.js { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  def change_status
    respond_to do |format|
      if @message.update(status: 'read')
        format.json do
          render json: {
            message_id: @message.id,
            status: @message.status
          }, status: 200
        end
      end
    end
  end

  def new
    @messageble_ussers = User.active.messagable(current_user.id)
    @body, @title, @recipient_id = '' 
    @message = Message.new
    if params[:reply_message]
      @reply_message = Message.find_by_id(params[:reply_message])
      if @reply_message
        @body = @reply_message.reply_body
        @title = @reply_message.reply_title
        @recipient_id = @reply_message.sender.id
      end
    end
    if params[:recipient_id]
      @recipient_id = params[:recipient_id] 
    end
    if !@recipient_id.blank?
      @messageble_ussers = User.where(id: @recipient_id)
      if @recipient_id.to_i == current_user.id
        flash[:error] = "You can't send messages to yourself"
        redirect_to :back
      end
    end
  end

  def destroy
    respond_to do |format|
      format.js if @message.destroy
    end
  end

  def destroy_multiple
    Message.destroy(params[:message])
    respond_to do |format|
      format.html { redirect_to messages_path }
    end
  end

  private

  def get_message
    @message = Message.find(params[:id])
  end
 
  def get_q
    @q = Item.ransack(params[:q])
  end

  def message_params
    params.require(:message).permit(:title, :body, :recipient_id)
  end
end
