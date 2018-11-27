# == Schema Information
#
# Table name: messages
#
#  id           :integer          not null, primary key
#  sender_id    :integer
#  recipient_id :integer
#  title        :string
#  body         :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  status       :string           default("new")
#  sender_role  :string           default("buyer")
#

class Message < ActiveRecord::Base

  belongs_to :sender, polymorphic: true
  belongs_to :recipient, polymorphic: true

  #  validates_presence_of :body, :title, :sender, :recipient

  default_scope { order('status ASC').order('created_at DESC') }

  scope :by_sender_id_and_recipient_id, lambda {|sender_id, recipient_id| 
    where(:sender_id=>sender_id).where(:recipient_id=>recipient_id).where(:sender_type => :reciepint_type)
  }

  scope :unread, -> { where(status: :new) }

  as_enum :status, [:read, :new], source: :status, map: :string
  as_enum :sender_role, [:buyer, :seller, :admin] , source: :sender_role, map: :string

  def created_date
    if self.created_at.today?
      self.created_at.strftime("%H:%M ")
    else
      self.created_at.strftime("%F")
    end
  end

  def get_by_user_id(user_id)
    Message.where('recipient_id=? OR sender_id=?', user_id, user_id)
  end

  def sender_name
    sender = self.sender
    if sender
      sender_name = sender.first_name + ' ' + sender.last_name
      return sender_name
    end
  end

  def sender_email
    sender = self.sender
    if sender
      sender_email = sender.email
      return sender_email
    end
  end

  def recipient_name
    recipient = self.recipient
    if recipient
      recipient_name = recipient.first_name + ' ' + recipient.last_name
      return recipient_name
    end
  end

  def recipient_email
    recipient = self.recipient
    if recipient
      recipient_email = recipient.email
      return recipient_email
    end
  end

  def reply_body
    "\n"  + '-'*10 + self.created_date + '-'*10  +  "\n"  + self.body
  end

  def reply_title
    "RE:#{self.title}"
  end
end
