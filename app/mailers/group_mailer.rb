class GroupMailer < ApplicationMailer

  def invite_to_group(user, emails, group)
    @user = user
    @emails = emails
    @group = group
    
    mail :to => emails, :subject => "You were invited to a group!"
  end

  def new_group_approval(group)
    @group = group
    mail :to => 'admin@groupnshop.com', :subject => "New group approval." 
  end

  def group_approved(user, group)
    @user = user
    @group = group
    mail :to => user.email, :subject => "Your group approved." 
  end

  def new_group(user, group)
    @user = user
    @group = group
    mail :to => user.email, :subject => "Your request has been sent to the site Administrator." 
  end

  def join_request(user, group)
    @user = user
    @group = group
    mail :to => user.email, :subject => "Request to join group."
  end

  def new_user(admin, group)
    @admin = admin
    @group = group
    mail :to => admin.email, :subject => "Someone asks to join your group."
  end

end
