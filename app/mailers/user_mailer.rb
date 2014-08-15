class UserMailer < ActionMailer::Base
  default from: ENV['GMAIL_USERNAME']

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.signup_confirmation.subject
  #
  def signup_confirmation(user)
    @user = user
    @url = verify_emails_user_url(@user,
                                  email_token: @user.email_token)

    mail to: user.email, subject: 'Signup Confirmation'
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: 'Password Reset'
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
