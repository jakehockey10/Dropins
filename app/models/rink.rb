class Rink < ActiveRecord::Base
  groupify :group_member
  has_many :dropins
  geocoded_by :address
  after_validation :geocode
  validates :name, presence: true, uniqueness: true
  validates :address, presence: true, uniqueness: true
end
