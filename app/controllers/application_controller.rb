class ApplicationController < ActionController::Base
  helper_method :mailbox, :unread_count

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

  after_filter :flash_to_headers

  private

    def mailbox
      @mailbox ||= current_user.mailbox
    end

    def unread_count
      @unread_count = mailbox.inbox(read: false).count(:id, distinct: true).to_s
    end

  def flash_to_headers
      return unless request.xhr?
      response.headers['X-message'] = flash_message
      response.headers['X-message-type'] = flash_type.to_s

      flash.discard # don't want the flash to appear when you reload the page.
    end

    def flash_message
      [:error, :warning, :notice].each do |type|
        return flash[type] unless flash[type].blank?
      end
    end

    def flash_type
      [:error, :warning, :notice].each do |type|
        return type unless flash[type].blank?
      end
    end
end
