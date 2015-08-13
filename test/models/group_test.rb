require 'test_helper'

class GroupTest < ActiveSupport::TestCase
  def setup
    @group = Group.new(name: 'LLUA')
  end

  test 'should be valid' do
    assert @group.valid?
  end

  test 'name should be present' do
    @group.name = '   '
    assert_not @group.valid?
  end

  test 'name should not be too long' do
    @group.name = 'a' * 21
    assert_not @group.valid?
  end
end
