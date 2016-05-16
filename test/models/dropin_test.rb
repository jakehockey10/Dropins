require 'test_helper'

class DropinTest < ActiveSupport::TestCase

  def setup
    @dropin = Dropin.new(date:        Time.now + 2.days,
                         rink:        rinks(:promenade),
                         limit:       20,
                         price:       20,
                         description: "Jake's Dropin",
                         user: users(:jake))
    @small_dropin = Dropin.new(date: Time.now + 2.days,
                               rink: rinks(:promenade),
                               limit: 0,
                               price: 20,
                               description: 'Already full',
                               user: users(:jake))
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

  test 'is_not_full' do
    assert @dropin.is_not_full
  end

  test 'is_full' do
    assert @small_dropin.is_full
  end

  test 'user_is_not_attending' do
    assert @dropin.user_is_not_attending(users(:jake))
  end

  test 'name is description' do
    assert_equal @dropin.name, @dropin.description
  end

  test 'user_paid' do
    dropin = dropins(:llua)
    assert dropin.user_paid(users(:michael))
    assert_not dropin.user_paid(users(:jake))
    assert_not dropin.user_paid(nil)
    assert_not dropin.user_paid(User.new)
    Attendance.new(user_id: users(:archer).id, dropin_id: dropin.id).save
    assert_not dropin.user_paid(users(:archer))
  end

  # TODO: Move to integration or helper
  # test 'context is correct' do
  #   assert_equal @dropin.skater_context(@dropin.user), 'You created this dropin!'
  #   assert_equal @dropin.skater_context(users(:michael)), 'You are skating in this dropin!'
  #   assert_equal @dropin.skater_context(users(:archer)), 'You skated in this dropin!'
  # end
end
