require 'test_helper'

class UserMailerTest < ActionMailer::TestCase

  test 'account_activation' do
    user = users(:jake)
    user.activation_token = User.new_token
    mail = UserMailer.account_activation(user)
    assert_equal 'Account activation', mail.subject
    assert_equal [user.email], mail.to
    assert_equal [ENV['SENDGRID_USERNAME']], mail.from
    assert_match user.name, mail.body.encoded
    assert_match user.activation_token, mail.body.encoded
    assert_match CGI::escape(user.email), mail.body.encoded
  end

  test 'password_reset' do
    user = users(:jake)
    user.reset_token = User.new_token
    mail = UserMailer.password_reset(user)
    assert_equal 'Password reset', mail.subject
    assert_equal [user.email], mail.to
    assert_equal [ENV['SENDGRID_USERNAME']], mail.from
    assert_match user.reset_token, mail.body.encoded
    assert_match CGI::escape(user.email), mail.body.encoded
  end

  test 'help_request' do
    user = users(:jake)
    user.help_token = User.new_token
    # mail = UserMailer.get_help(user)
    mail = user.send_help_request_email('I need help!')
    assert_equal 'Dropins: User needs help', mail.subject
    assert_equal [ENV['SENDGRID_USERNAME']], mail.to
    assert_equal [user.email], mail.from
    # TODO: Why doesn't this one need to be escaped like the others?
    # assert_match CGI::escape(user.email), mail.body.encoded
    assert_match user.email, mail.body.encoded
    assert_match user.name, mail.body.encoded
    assert_match 'I need help!', mail.body.encoded
  end

  test 'dropin_creator_email' do
    dropin = dropins(:llua)
    creator = dropin.user
    user = users(:archer)
    message = 'Thank you so much for putting this together!'
    mail = UserMailer.dropin_creator_email(dropin, user, message)
    assert_equal "Message from skater of your #{dropin.date.strftime('%A, %B %d')} dropin", mail.subject
    assert_equal [creator.email], mail.to
    assert_equal [user.email], mail.from
    assert_match user.email, mail.body.encoded
    assert_match user.name, mail.body.encoded
    assert_match dropin.date.strftime('%A, %B %d'), mail.body.encoded
    assert_match 'Thank you so much for putting this together!', mail.body.encoded
  end
end
