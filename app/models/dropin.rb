class Dropin < ActiveRecord::Base
  has_many :attendances
  has_many :skaters, through: :attendances, source: :user

  validates :date,
            presence: true,
            date: { after: Proc.new { Time.zone.now },
                    before: Proc.new { Time.now + 1.year } }
end
