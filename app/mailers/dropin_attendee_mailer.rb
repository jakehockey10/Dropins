class DropinAttendeeMailer < ActionMailer::Base
  default from: ENV['SENDGRID_USERNAME']

  def email_attendees(user_id, users, dropin_id, subject, message)
    @owner = User.find(user_id)
    @users = users
    @dropin = Dropin.find(dropin_id)
    @url = dropin_url(dropin_id)
    @signup_url = signup_url
    @subject = subject
    @message = message
    mail to: users, subject: subject, from: @owner.email
  end
end
