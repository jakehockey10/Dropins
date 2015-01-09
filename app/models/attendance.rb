class Attendance < ActiveRecord::Base
  belongs_to :user
  belongs_to :dropin

  validates :user_id,   presence: true, uniqueness: { scope: :dropin_id }
  validates :dropin_id, presence: true, uniqueness: { scope: :user_id }
end
