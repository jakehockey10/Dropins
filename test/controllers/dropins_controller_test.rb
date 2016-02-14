require 'test_helper'

class DropinsControllerTest < ActionController::TestCase

  def setup
    @dropin = dropins(:llua)
    @other_dropin = dropins(:silly_dropin)
    @user = users(:michael)
    @admin = users(:jake)
  end

  test 'should redirect index when not logged in' do
    get :index
    assert_redirected_to login_url
  end

  test 'should redirect new when not logged in' do
    get :new
    assert_redirected_to login_url
  end

  test 'should redirect create when not logged in' do
    post :create
    assert_redirected_to login_url
  end

  test 'should redirect edit when not logged in' do
    get :edit, id: @dropin
    assert_redirected_to login_url
  end

  test 'should redirect update when not logged in' do
    put :update, id: @dropin
    assert_redirected_to login_url
    patch :update, id: @dropin
    assert_redirected_to login_url
  end

  test 'should redirect show when not logged in' do
    get :show, id: @dropin
    assert_redirected_to login_url
  end

  test 'should redirect delete when not logged in' do
    delete :destroy, id: @dropin, method: :destroy
    assert_redirected_to login_url
  end

  test 'should redirect edit if logged in but not admin' do
    log_in_as @user
    get :edit, id: @dropin
    assert_redirected_to root_url
  end

  test 'should redirect update if logged in but not admin' do
    log_in_as @user
    put :update, id: @dropin
    assert_redirected_to root_url
    patch :update, id: @dropin
    assert_redirected_to root_url
  end

  test 'should redirect new if logged in but not admin' do
    log_in_as @user
    get :new
    assert_redirected_to root_url
  end

  test 'should redirect create if logged in but not admin' do
    log_in_as @user
    post :create
    assert_redirected_to root_url
  end

  test 'should redirect destroy if logged in but not admin' do
    log_in_as @user
    delete :destroy, id: @dropin
    assert_redirected_to root_url
  end

  test 'should get show' do
    log_in_as @user
    get :show, id: @dropin
    assert_response :success
  end

  test 'should get index' do
    log_in_as @user
    get :index
    assert_response :success
  end

  test 'should get new' do
    log_in_as @admin
    get :new
    assert_response :success
  end

  test 'should post create' do
    log_in_as @admin
    post :create, dropin: { date: Time.now + 1.day, price: 15, rink_id: rinks(:promenade), limit: 20, description: 'Pretty cool, I guess.' }
    assert_redirected_to dropin_path(assigns(:dropin))
  end

  test 'should get edit' do
    log_in_as @admin
    get :edit, id: @dropin
    assert_response :success
  end

  test 'should put update' do
    log_in_as @admin
    put :update, id: @dropin, dropin: { date: (Time.now + 2.days).strftime('%m/%d/%Y %I:%M %p'), price: 40 }
    assert_redirected_to @dropin
  end

  test 'should delete destroy' do
    log_in_as @admin
    delete :destroy, id: @dropin, method: :delete
    assert_redirected_to dropins_path
  end

end