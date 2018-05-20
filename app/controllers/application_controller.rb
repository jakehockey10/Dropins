class ApplicationController < ActionController::Base
  helper_method :mailbox, :unread_count

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

  after_action :flash_to_headers

  private

  # Confirms user is skater of dropin
  def skater?
    @user = current_user
    @dropin = Dropin.find(email_params[:dropin_id])
    unless @user && @dropin.skaters.include?(@user)
      flash[:info] = 'You must be skating in this dropin to message the dropin coordinator directly.'
      redirect_to dropin_path(@dropin)
    end
  end

  # Confirms a logged-in user.
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = 'Please log in.'
      redirect_to login_url
    end
  end

  # Confirms an admin user.
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

  def mailbox
    @mailbox ||= current_user.mailbox
  end

  def unread_count
    @unread_count = mailbox.inbox(read: false).count(:id).to_s
  end

  def flash_to_headers
    return unless request.xhr?
    response.headers['X-message'] = flash_message
    response.headers['X-message-type'] = flash_type.to_s

    flash.discard # don't want the flash to appear when you reload the page.
  end

  def flash_message
    %i[error warning notice].each do |type|
      return flash[type] unless flash[type].blank?
    end
  end

  def flash_type
    %i[error warning notice].each do |type|
      return type unless flash[type].blank?
    end
  end
end
