class DisputMailer < ApplicationMailer
  def open_disput(user, disput)
    @user = user
    @disput = disput
    @listing = disput.item
    mail :to => user.email, :subject => "Open Disput"
  end
end
