require 'test_helper'

class AttendancesControllerTest < ActionController::TestCase

  def setup
    @dropin = dropins(:llua)
    @michael = users(:michael)
  end

  test 'should redirect create if not logged in' do
    post :create, attendance: { dropin_id: @dropin, user_id: @michael, paid: false }
    assert_redirected_to login_url
  end

  test 'should redirect destroy if not logged in' do
    delete :destroy, id: attendances(:one)
    assert_redirected_to login_url
  end

  test 'should post create' do
    log_in_as users(:archer)
    post :create, attendance: { dropin_id: @dropin, user_id: users(:archer), paid: false }
    assert_redirected_to @dropin
  end

  test 'should delete destroy' do
    log_in_as @michael
    attendance = attendances(:two)
    delete :destroy, id: attendance, attendance: { user_id: @michael }
  end

end