class ReferralController < ApplicationController
  before_filter :authenticate_user!
  def index
  end

  def invite
    user = current_user
    emails = params[:email].split(',')
    sended = ''
    invalid = ''
    emails.each do |email|
      email = email.downcase.delete(' ')
      if email.count("@") != 1
        if invalid.blank?
          invalid += email
        else
          invalid += ', ' + email
        end
      elsif email =~ /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
        if sended.blank?
          sended += email 
        else
          sended += ', ' + email
        end
      else
        if invalid.blank?
          invalid += email
        else
          invalid += ', ' + email
        end
      end
    end
    # body = params[:comments]
    if !sended.blank?
      flash[:success] = 'Invite sent to ' + sended +'.'
      sended = sended.split(',')
      ReferralMailer.referral_email(user, sended, '').deliver_now
    end
    if !invalid.blank?
      flash[:error] = '"' + invalid + '"' + ' is not valid.'
    end
    redirect_to invite_path
  end
end
