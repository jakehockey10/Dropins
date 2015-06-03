require 'test_helper'

class UserShowTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:jake)
    @other_user = users(:michael)
  end

  test 'user show gets redirected if user shown not activated' do
    @other_user.update_attribute(:activated, false)
    log_in_as @user
    get user_path(@other_user)
    assert_redirected_to root_url
    @other_user.update_attribute(:activated, true)
    get user_path(@other_user)
    assert_response :success
    assert_template 'users/show'
  end
end
