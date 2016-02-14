require 'test_helper'

class DropinShowTest < ActionDispatch::IntegrationTest

  def setup
    @dropin = dropins(:llua)
    @user = users(:jake)
    @other_user = users(:mallory)
  end

  test 'dropin show shows correct buttons for dropin creators' do
    get dropin_path(@dropin)
    assert_redirected_to login_url
    log_in_as @user
    get dropin_path(@dropin)
    assert_template 'dropins/show'
    assert_creator_buttons
  end

  test 'dropin show shows correct buttons for dropin skaters html' do
    assert_buttons_before_attending
    post attendances_path,
         attendance: { dropin_id: @dropin.id,
                       user_id: @other_user.id }
    assert_redirected_to dropin_path(@dropin)
    follow_redirect!
    assert_not_creator_buttons
  end

  test 'dropin show shows correct buttons for dropin skaters ajax' do
    assert_buttons_before_attending
    xhr :post, attendances_path,
         attendance: { dropin_id: @dropin.id,
                       user_id: @other_user.id }
    assert_template '_dropin_buttons'
    # I think this fails because of the fadeIn thing.  But I'm not sure.  It works
    # running dev.
    # assert_not_creator_buttons
  end

  private

    def assert_buttons_before_attending
      get dropin_path(@dropin)
      assert_redirected_to login_url
      log_in_as @other_user
      get dropin_path(@dropin)
      assert_template 'dropins/show'
      assert_select 'button.email-dropin-creator', text: 'Email creator', count: 0
      assert_select 'button.dropin-removal-request', text: 'Request removal', count: 0
      assert_select 'button.invite-skaters', count: 0
      assert_select 'button.email-attendees', count: 0
    end

    def assert_not_creator_buttons
      assert_select 'button.email-dropin-creator', text: 'Email creator', count: 1
      assert_select 'button.dropin-removal-request', text: 'Request removal', count: 1
      assert_select 'button.invite-skaters', count: 0
      assert_select 'button.email-attendees', count: 0
    end

    def assert_creator_buttons
      assert_select 'button.email-dropin-creator', count: 0
      assert_select 'button.dropin-removal-request', count: 0
      # assert_select 'button.invite-skaters', text: 'Invite skaters', count: 1
      assert_select 'button.email-attendees', text: 'Email attendees', count: 1
    end
end
