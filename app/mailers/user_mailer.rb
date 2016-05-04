class UserMailer < ApplicationMailer

  def account_activation(user)
    @user = user
    mail to: user.email, subject: 'Account activation'
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: 'Password reset'
  end

  def help_request(user, message)
    @user = user
    @message = message
    mail to: ENV['SENDGRID_USERNAME'], from: user.email, subject: 'Dropins: User needs help'
  end

  def dropin_creator_email(dropin, user, message)
    @dropin = dropin
    @user = user
    @message = message
    mail to: dropin.user.email, from: user.email, subject: "Message from skater of your #{@dropin.date.strftime('%A, %B %d')} dropin"
  end

  def dropin_removal_request(dropin, user, message = 'No message was given.')
    @dropin = dropin
    @user = user
    @message = message
    mail to: dropin.user.email, from: user.email, subject: "Request to be removed from your #{@dropin.date.strftime('%A, %B %d')} dropin"
  end

  def invite_users_to_dropin(user_id, users, dropin_id, message)
    @user = User.find(user_id)
    @users = users
    @dropin = Dropin.find(dropin_id)
    @url = dropin_url(dropin_id)
    @signup_url = signup_url
    @message = message
    mail to: users, subject: "Invited to dropin by #{@user.name}", from: @user.email
  end
end
