class DropinRemovalRequestsController < ApplicationController
  before_action :logged_in_user
  before_action :is_skater, only: :create

  def create
    if @user && @dropin
      @user.create_dropin_removal_digest
      @user.send_dropin_removal_request(@dropin, email_params[:message])
      flash[:info] = "Request sent.  You will receive an email confirming the dropin coordinator's acknowledgement of this request."
      redirect_to dropin_path(@dropin)
    else
      # TODO: put a parameter in that link to use for better support from the start.
      # TODO: the %Q[] syntax is so that you can put ruby syntax in for a parameter.
      # See http://stackoverflow.com/questions/2249431/put-a-link-in-a-flashnotice
      flash[:danger] = %Q[Something went wrong.  Could you let me know about it <a href="/help_requests/new">here</a>.]
    end
  end

  def edit
    dropin = Dropin.find(params[:dropin_id])
    user = User.find(params[:user_id])
    attendance = Attendance.find_by(user_id: user.id, dropin_id: dropin.id)
    if attendance && user.authenticated?(:dropin_removal, params[:id])
      attendance.destroy
      flash[:success] = 'Skater successfully removed from the dropin!'
      redirect_to dropin_path(dropin)
    else
      flash[:danger] = 'Invalid activation link'
      redirect_to dropin_path(dropin)
    end
  end

  private

    def email_params
      params.require(:dropin_removal_request).permit(:dropin_id, :user_id, :message)
    end
end
