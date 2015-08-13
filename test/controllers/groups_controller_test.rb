require 'test_helper'

class GroupsControllerTest < ActionController::TestCase

  def setup
    @user = users(:jake)
    @other_user = users(:michael)
    @group = groups(:llua)
  end

  test 'should redirect index when not logged in' do
    get :index
    assert_redirected_to login_url
  end

  test 'should redirect new when not admin' do
    log_in_as(users(:michael))
    get :new
    assert_redirected_to root_url
  end

  test 'should get new if admin' do
    log_in_as(users(:jake))
    get :new
    assert_response :success
  end

  test 'should redirect create when not admin' do
    log_in_as(users(:michael))
    assert_no_difference 'Group.count' do
      post :create, group: {}
    end
    assert_redirected_to root_url
  end

  test 'should redirect destroy when not logged in' do
    assert_no_difference 'Group.count' do
      delete :destroy, id: groups(:llua)
    end
  end

  test 'should redirect destroy if logged in as non-admin' do
    log_in_as(@other_user)
    assert_no_difference 'Group.count' do
      delete :destroy, id: @group
    end
    assert_redirected_to root_url
  end
end
