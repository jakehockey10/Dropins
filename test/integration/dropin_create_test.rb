require 'test_helper'

class DropinCreateTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:jake)
  end

  test 'invalid dropin shows error explanation' do
    log_in_as @user
    get dropins_path
    assert_select 'form#new_dropin', count: 1
    assert_select '#error_explanation > .alert.alert-danger.card-alert', count: 0
    xhr :post, dropins_path, dropin: { date: '', price: '', rink: '', user: '', limit: '' }
    assert_select 'form#new_dropin', count: 1
    assert_select '#error_explanation > .alert.alert-danger.card-alert', count: 1
  end

end