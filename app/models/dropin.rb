class Dropin < ActiveRecord::Base
  has_many :attendances
  has_many :skaters, through: :attendances, source: :user

  validates :date,
            presence: true,
            date: { after: Proc.new { Time.zone.now.to_time.strftime('%c').to_datetime },
                    before: Proc.new { Time.now + 1.year } }
end
