class Rink < ActiveRecord::Base
  has_many :dropins
  geocoded_by :address
  after_validation :geocode
  validates :name, presence: true, uniqueness: true
  validates :address, presence: true, uniqueness: true
end
