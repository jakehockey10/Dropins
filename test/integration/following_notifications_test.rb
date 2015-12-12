require 'test_helper'

class FollowingNotificationsTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:jake)
    @other = users(:archer)
    log_in_as(@user)
  end

end
