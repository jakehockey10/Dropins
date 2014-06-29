class Dropin < ActiveRecord::Base
  # has_many :attendances
  # has_many :skaters, through: :attendances, source: :user
  has_many :commitments,
           dependent: :destroy
  has_many :skaters, through: :commitments, source: :user
  belongs_to :rink
  belongs_to :user

  validates :date,
            presence: true,
            date: { after: Proc.new { Time.now - 1.minute },
                    before: Proc.new { Time.now + 1.year } }
  validates :price, presence: true
  validates :rink, presence: true
end
