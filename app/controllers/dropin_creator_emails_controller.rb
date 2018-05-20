class DropinCreatorEmailsController < ApplicationController
  before_action :logged_in_user
  before_action :skater?

  def create
    if @user && @dropin
      @user.send_email_to_dropin_creator(@dropin, email_params[:message])
      flash[:info] = 'Message sent!'
      redirect_to dropin_path(@dropin)
    else
      # TODO: put a parameter in that link to use for better support from the start.
      # TODO: the %Q[] syntax is so that you can put ruby syntax in for a parameter.
      # See http://stackoverflow.com/questions/2249431/put-a-link-in-a-flashnotice
      flash[:danger] = %Q[Something went wrong.  Could you let me know about it <a href="/help_requests/new">here</a>.]
    end
  end

  private

    def email_params
      params.require(:dropin_creator_email).permit(:dropin_id, :user_id, :message)
    end
end
