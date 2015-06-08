require 'test_helper'

class EmailDropinCreatorTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
    @dropin = dropins(:llua)
    @other_dropin = dropins(:silly_dropin)
    @creator = @dropin.user
    @non_skater = users(:mallory)
    @skater = users(:archer)
  end

  test 'email dropin creators with logged in user that is not skating' do
    # not logged in
    get dropin_path(@dropin)
    assert_redirected_to login_path
    # logged in as non_skater
    log_in_as @non_skater
    get dropin_path(@dropin)
    post email_dropin_creators_path,
         email_dropin_creator: { dropin_id: @dropin.id,
                                 user_id: @non_skater.id }
    assert_not flash.empty?
    assert_redirected_to dropin_path(@dropin)
    follow_redirect!
    assert_match 'You must be skating in this dropin to message the dropin coordinator directly.', response.body
    # logged in as skater
    delete logout_path
    log_in_as @skater
    get dropin_path(@dropin)
    post attendances_path,
         attendance: { dropin_id: @dropin.id,
                       user_id: @skater.id }
    post email_dropin_creators_path,
         email_dropin_creator: { dropin_id: @dropin.id,
                                 user_id: @skater.id,
                                 message: 'Thanks for the skate this week, dude!' }
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to dropin_path(@dropin)
    follow_redirect!
    assert_match 'Message sent!', response.body
  end
end
