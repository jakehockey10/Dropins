class HelpRequestsController < ApplicationController
  before_action :logged_in_user
  before_action :no_blank_messages, only: :create

  def new
  end

  def create
    @user = User.find_by(email: help_request_params[:email].downcase)
    if @user
      @user.create_help_request_digest
      @user.send_help_request_email(help_request_params[:message])
      flash[:info] = 'Email sent to site administrator.  Help is on its way!'
      redirect_to root_url
    else
      flash.now[:danger] = 'Email address not found'
      render 'new'
    end
  end

  private

    def help_request_params
      params.require(:help_request).permit(:email, :message)
    end

    def no_blank_messages
      # TODO: Does this type of validation belong in a model class?
      if params[:help_request][:message].length < 1
        flash.now[:danger] = "Please don't send us empty messages!"
        render 'new'
      end
    end
end
