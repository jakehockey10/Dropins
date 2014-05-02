class UserMailer < ActionMailer::Base
  default from: 'therosenbridge@gmail.com'

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
end
