class HelpRequestsController < ApplicationController
  before_action :logged_in_user

  def new
  end

  def create
    @user = User.find_by(email: params[:help_request][:email].downcase)
    if @user
      @user.create_help_request_digest
      @user.send_help_request_email(params[:help_request][:message])
      flash[:info] = 'Email sent to site administrator.  Help is on its way!'
      redirect_to root_url
    else
      flash.now[:danger] = 'Email address not found'
      render 'new'
    end
  end
end
