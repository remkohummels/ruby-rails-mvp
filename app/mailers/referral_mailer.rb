class ReferralMailer < ApplicationMailer

  def referral_email(user, emails, body)
    @user = user
    @emails = emails
    @body = body
    @emails.each do |email|
      @email = email
      mail :to => @email, :subject => "Join Us!"
    end
  end
end

