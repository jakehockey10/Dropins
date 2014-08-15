class Invite < ActiveRecord::Base
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  validates :login, presence: true, format: { with: VALID_EMAIL_REGEX }
  validates :password, presence: true
end
