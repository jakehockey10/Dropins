class GmailContact < ActiveRecord::Base
  belongs_to :user

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  validates :name, presence: true
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }
  validates :user_id, presence: true

  def get_email_from_name
    self.email
  end
end
