class NotificationCleanupJob < ApplicationJob
  queue_as :default

  def perform(*args)
    ActivityNotification::Notification.where('created_at < ?', 5.minutes.ago).destroy_all
  end

  after_perform do |job|
    self.class.set(wait: 5.minutes).perform_later
  end
end
