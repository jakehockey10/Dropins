class GmailContact < ActiveRecord::Base
  belongs_to :user

  def get_email_from_name
    self.email
  end
end
