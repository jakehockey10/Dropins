require 'test_helper'

class HelpRequestsTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:archer)
  end

  test 'should redirect if not logged in' do
    get new_help_request_path
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test 'help page' do
    log_in_as @user
    get new_help_request_path
    assert_template 'help_requests/new'
    # Invalid email
    post help_requests_path, help_request: { email: '', message: 'HELP!' }
    assert_not flash.empty?
    assert_template 'help_requests/new'
    # Empty message
    post help_requests_path, help_request: { email: @user.email, message: '' }
    assert_not flash.empty?
    assert_template 'help_requests/new'
    # Valid email
    post help_requests_path, help_request: { email: @user.email, message: 'HELP!' }
    assert_not_equal @user.help_digest, @user.reload.help_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url
  end
end
