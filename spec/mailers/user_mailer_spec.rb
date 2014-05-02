require 'spec_helper'

describe UserMailer do
  describe 'signup_confirmation' do
    let(:user) { FactoryGirl.create(:user) }
    let(:mail) { UserMailer.signup_confirmation(user) }

    it 'renders the headers' do
      mail.subject.should eq('Signup Confirmation')
      mail.to.should eq([user.email])
      mail.from.should eq([ENV['ROSENBRIDGE_GMAIL_USERNAME']])
    end

    it 'renders the body' do
      mail.body.encoded.should have_content(user.name)
      mail.body.encoded.should have_content('Verify my email!')
      mail.body.encoded.should have_link('Verify my email!', href: verify_emails_user_url(user, email_token: user.email_token))
    end
  end

  describe 'password reset' do
    let(:user) { FactoryGirl.create(:user) }
    let(:mail) { UserMailer.password_reset(user) }

    it 'renders the headers' do
      mail.subject.should eq('Password Reset')
      mail.to.should eq([user.email])
      mail.from.should eq([ENV['ROSENBRIDGE_GMAIL_USERNAME']])
    end

    it 'renders the body' do
      mail.body.encoded.should have_content(user.name)

    end
  end
end
