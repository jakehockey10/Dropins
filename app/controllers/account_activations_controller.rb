class AccountActivationsController < ApplicationController

  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = 'Account activated!'
      redirect_to user
    else
      flash[:danger] = %Q[Invalid activation link.  Could you let me know about it <a href="/help_requests/new">here</a>.]
      redirect_to root_url
    end
  end
end
