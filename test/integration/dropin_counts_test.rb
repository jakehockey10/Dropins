require 'test_helper'

class DropinCountsTest < ActionDispatch::IntegrationTest

  def setup
    @admin = users(:jake)
    @dropin = dropins(:llua)
  end

  test 'should not see duplicate dropins' do
    log_in_as @admin
    get dropins_path
    assert_equal(1, response.body.scan(/This used to be a weekly thing./).count)
  end

end
