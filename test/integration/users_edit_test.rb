require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:jake)
  end

  test 'unsuccessful edit' do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), user: { first_name: '',
                                    second_name: '',
                                    email: 'foo@invalid',
                                    password: 'foo',
                                    password_confirmation: 'bar' }
    assert_template 'users/edit'
  end

  test 'successful edit with friendly forwarding' do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    assert_equal session[:forwarding_url], nil
    first_name  = 'Foo'
    second_name = 'Bar'
    email = 'foo@bar.com'
    patch user_path(@user), user: { first_name:  first_name,
                                    second_name: second_name,
                                    email: email,
                                    password: 'foobar',
                                    password_confirmation: 'foobar'}
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal first_name + ' ' + second_name,  @user.name
    assert_equal email, @user.email
  end
end
