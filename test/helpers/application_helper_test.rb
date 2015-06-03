require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test 'full title helper' do
    assert_equal full_title, 'Dropins Beta'
    assert_equal full_title('Help'), 'Help | Dropins Beta'
  end
end