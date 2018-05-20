module EmailStripper
  extend ActiveSupport::Concern

  included do
    before_action :sanitize_email_param
  end

  private

  def sanitize_email_param
    params.first[:email].downcase.strip if params.dig(:email)
  end
end