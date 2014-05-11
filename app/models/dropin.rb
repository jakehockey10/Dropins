class Dropin < ActiveRecord::Base
  has_many :attendances
  has_many :skaters, through: :attendances, source: :user
  belongs_to :rink

  validates :date,
            presence: true,
            date: { after: Proc.new { Time.now - 1.minute },
                    before: Proc.new { Time.now + 1.year } }
  validates :price, presence: true
  validates :rink, presence: true
end
