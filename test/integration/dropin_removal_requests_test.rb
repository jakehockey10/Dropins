require 'test_helper'

class DropinRemovalRequestsTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
    @dropin = dropins(:llua)
    @user = users(:archer)
  end

  test 'request removal from dropin with logged in user' do
    log_in_as @user
    # join dropin
    post attendances_path,
        attendance: { dropin_id: @dropin.id,
                      user_id: @user.id }
    # request to be removed
    post dropin_removal_requests_path,
        dropin_removal_request: { dropin_id: @dropin.id,
                                  user_id: @user.id }
    # reload so that the digest and token are set.
    @user.reload
    user = assigns(:user)
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to dropin_path(@dropin)
    follow_redirect!
    # apparently I needed CGI.escapeHTML here.  I wonder if it was the apostrophe?
    assert_match CGI.escapeHTML("Request sent.  You will receive an email confirming the dropin coordinator's acknowledgement of this request."), response.body
    delete logout_path
    assert_difference 'Attendance.count', -1, 'an attendance should be destroyed' do
      get edit_dropin_removal_request_path(user.dropin_removal_token, dropin_id: @dropin.id, user_id: @user.id)
    end
  end

  test 'request removal for dropin that you user is not signed up for' do
    log_in_as @user
    post dropin_removal_requests_path,
        dropin_removal_request: { dropin_id: @dropin.id,
                                  user_id: @user.id }
    assert_equal 0, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to dropin_path(@dropin)
    follow_redirect!
    assert_match 'You must be skating in this dropin to message the dropin coordinator directly.', response.body
  end
end
