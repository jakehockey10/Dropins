class Attendance < ActiveRecord::Base
  belongs_to :user
  belongs_to :dropin
  validates :user_id, presence: true
  validates :dropin_id, presence: true
end
