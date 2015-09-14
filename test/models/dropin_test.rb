require 'test_helper'

class DropinTest < ActiveSupport::TestCase

  def setup
    @dropin = Dropin.new(date:        Time.now + 2.days,
                         rink:        rinks(:promenade),
                         limit:       20,
                         price:       20,
                         description: "Jake's Dropin")
  end

  test 'should be valid' do
    assert @dropin.valid?
  end

  test 'date should be newer than a minute ago' do
    @dropin.date = Time.now - 61.seconds
    assert_not @dropin.valid?
  end

  test 'date should be newer than a year from now' do
    @dropin.date = Time.now + 1.year + 1.second
    assert_not @dropin.valid?
  end

  test 'date should be present' do
    @dropin.date = nil
    assert_not @dropin.valid?
  end

  test 'price should be present' do
    @dropin.price = nil
    assert_not @dropin.valid?
  end

  test 'price should be positive' do
    @dropin.price = -0.01
    assert_not @dropin.valid?
  end

  test 'rink should be present' do
    @dropin.rink = nil
    assert_not @dropin.valid?
  end

  test 'limit should be present' do
    @dropin.limit = nil
    assert_not @dropin.valid?
  end

  test 'limit should be integer' do
    @dropin.limit = 0.5
    assert_not @dropin.valid?
  end

  test 'limit should be positive' do
    @dropin.limit = -1
    assert_not @dropin.valid?
  end

  test 'description should be present' do
    @dropin.description = '          '
    assert_not @dropin.valid?
  end

  test 'description should be long enough' do
    @dropin.description = 'a' * 9
    assert_not @dropin.valid?
  end

  test 'description should not be too long' do
    @dropin.description = 'a' * 141
    assert_not @dropin.valid?
  end
end
