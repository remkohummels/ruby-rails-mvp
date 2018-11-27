class Account::MessagesController < AccountBaseController
  before_filter :get_q, only: [:index, :new]
  before_filter :get_message, only: [:destroy, :change_status]

  def index
    @user = current_user
    @sent_msg_count = current_user.sent_messages.count
    if params[:type]=='sent'
      @messages = current_user.sent_messages
      @type = 'sent'
    else
      @messages = current_user.received_messages
      @type = 'inbox'
    end
    @message = Message.new
    respond_to do |format|
      format.html
      format.js {render layout: false}
    end
  end

  def feedback
    @message = Message.new
    @admin = AdminUser.first
  end

  def create
    @message = current_user.sent_messages.build message_params
    @message.sender_type = "User"
    messages = Message.by_sender_id_and_recipient_id(@message.recipient_id, @message.sender_id)
    if messages.present?
      if messages.last.buyer?
        @message.seller!
      end
    end
    respond_to do |format|
      if @message.save
        @messages = current_user.received_messages
        @type = 'inbox'
        @sent_msg_count = current_user.sent_messages.count
        format.js { render 'back_index', layout: false}
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
    @title = params[:title] if !params[:title].blank?
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
        @recipient_id = ''
      end
    end
    
    respond_to do |format|
      format.html { 
        @compose = true
        render 'index'
      }
      format.js {render layout: false}
    end
  end

  def show
    @msg = Message.find(params[:id])
    @sent = (@msg.sender_id == current_user.id)
    unless @sent
      @msg.status = :read
      @msg.save!
    end
    respond_to do |format|
      format.html
      format.js {render layout: false}
    end
  end

  def destroy
    respond_to do |format|
      format.js if @message.destroy
    end
  end

  def destroy_multiple
    Message.destroy(params[:ids])
    @sent_msg_count = current_user.sent_messages.count
    if params[:type]=='sent'
      @messages = current_user.sent_messages
      @type = 'sent'
    else
      @messages = current_user.received_messages
      @type = 'inbox'
    end
    respond_to do |format|
      format.js { render 'index', layout: false }
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
    params.require(:message).permit(:title, :body, :recipient_id, :recipient_type)
  end
end
