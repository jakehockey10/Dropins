class Contact < MailForm::Base
  attribute :email, validate: /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i
  attribute :email_token, validate: true
  attribute :language, validate: true
  attribute :nickname, captcha: true

  # Declare the e-mail headers. It accepts anything the mail method
  # in ActionMailer accepts.
  def headers
    {
        subject: 'Interested Person',
        to: ENV['GMAIL_USERNAME'],
        from: %("#{email}")
    }
  end

  def Contact.new_token
    SecureRandom.urlsafe_base64
  end

  def Contact.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end
end