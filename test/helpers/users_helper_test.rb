require 'test_helper'

class UsersHelperTest < ActionView::TestCase
  include UsersHelper

  def setup
    @jake = users(:jake)
    @lana = users(:lana)
    @mallory = users(:mallory)
  end

  test 'tokenfield_source helper' do
    followers = [
        {
            value: @lana.email,
            label: @lana.name,
            profile_picture: raw(avatar_for @lana, { size: :small, class: 'media-object' })
        },
        {
            value: @mallory.email,
            label: @mallory.name,
            profile_picture: raw(avatar_for @mallory, { size: :small, class: 'media-object' })
        }
    ]
    assert_equal tokenfield_source(@jake), raw(followers.to_json)
  end
end
