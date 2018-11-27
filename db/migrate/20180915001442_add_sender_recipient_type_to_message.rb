class AddSenderRecipientTypeToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :sender_type, :string
    add_column :messages, :recipient_type, :string
    add_index :messages, :recipient_id
    add_index :messages, :sender_id

    Message.find_each do |message|
      message.recipient_type = 'User'
      message.sender_type = 'User'
      message.save!
    end
  end
end
