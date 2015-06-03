require 'test_helper'

class UserMailerTest < ActionMailer::TestCase

  test 'account_activation' do
    user = users(:jake)
    user.activation_token = User.new_token
    mail = UserMailer.account_activation(user)
    assert_equal 'Account activation', mail.subject
    assert_equal [user.email], mail.to
    assert_equal [ENV['GMAIL_USERNAME']], mail.from
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
    assert_equal [ENV['GMAIL_USERNAME']], mail.from
    assert_match user.reset_token, mail.body.encoded
    assert_match CGI::escape(user.email), mail.body.encoded
  end

  # test 'get_help' do
  #   user = users(:jake)
  #   user.reset_token = User.new_token
  #   mail = UserMailer.get_help(user)
  #   assert_equal 'Dropins: User needs help', mail.subject
  #   assert_equal [ENV['GMAIL_USERNAME']], mail.to
  #   assert_equal [user.email], mail.from
  #   assert_match CGI::escape(user.email), mail.body.encoded
  # end
end
