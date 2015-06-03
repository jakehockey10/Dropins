class UserMailer < ApplicationMailer

  def account_activation(user)
    @user = user
    mail to: user.email, subject: 'Account activation'
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: 'Password reset'
  end

  def get_help(user)
    @user = user
    mail to: ENV['GMAIL_USERNAME'], from: user.email, subject: 'Dropins: User needs help'
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
