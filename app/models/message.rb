class Message < ActiveRecord::Base
  validates :recipient_id, presence: true
  validates :sender_id, presence: true
  belongs_to :sender, foreign_key: :sender_id, class_name: 'User'
  belongs_to :recipient, foreign_key: :recipient_id, class_name: 'User'
end