class Group < ActiveRecord::Base
  groupify :group, members: [:users, :dropins, :rinks], default_members: :users

  validates :name, presence: true, length: { maximum: 20 }
end
