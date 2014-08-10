class Dropin < ActiveRecord::Base
  has_many :attendances
  has_many :skaters, through: :attendances, source: :user
  # has_many :commitments,
  #          dependent: :destroy
  # has_many :skaters, through: :commitments, source: :user
  belongs_to :rink
  belongs_to :user

  validates :date,
            presence: true,
            date: { after: Proc.new { Time.now - 1.minute },
                    before: Proc.new { Time.now + 1.year } }
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :rink, presence: true
  validates :limit, presence: true, numericality: { only_integer: true, greater_than: 0 }

  def is_not_full
    self.limit > self.skaters.count
  end

  def user_is_not_attending(user_id)
    attendances.count === 0 || attendances.find_by(user_id: user_id).nil?
  end
end
