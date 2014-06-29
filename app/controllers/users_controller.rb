class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy, :following, :followers]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @q = User.ransack(params[:q])
    @users = @q.result.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
    redirect_to_root_if_signed_in
    @user = User.new
  end

  def create
    redirect_to_root_if_signed_in

    @user = User.new(user_params)

    if @user.save
      sign_in @user
      @user.update_attribute(:email_token, User.encrypt(User.new_token))
      UserMailer.signup_confirmation(@user).deliver
      flash[:success] = 'Welcome to Dropins Beta!  Please verify the email you provided by clicking the link we sent to you.'
      redirect_to root_path
    else
      render 'new'
    end
  end

  def edit
  end

  def verify_emails
    @user = User.find_by(email_token: params[:email_token])
    @user.activate!
    flash[:success] = 'Your email has been verified!'
    redirect_to @user
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = 'Profile updated'
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = 'User deleted.'
    redirect_to users_url
  end

  def following
    @title = 'Following'
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = 'Followers'
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  # GET /users/oauth/1
  def oauth
    if !params[:code]
      return redirect_to root_path
    end

    redirect_uri = url_for(controller: 'users', action: 'oauth', user_id: params[:user_id], host: request.host_with_port)
    @user = User.find(params[:user_id])
    begin
      @user.request_wepay_access_token(params[:code], redirect_uri)
    rescue Exception => e
      error = e.message
    end

    if error
      flash[:danger] = error
    else
      flash[:success] = 'We successfully connected you to WePay!'
    end
    redirect_to @user
  end

  private

    def user_params
      params.require(:user).permit(:first_name,
                                   :second_name,
                                   :email,
                                   :password,
                                   :password_confirmation,
                                   :wepay_access_token,
                                   :wepay_account_id)
    end

    def redirect_to_root_if_signed_in
      if signed_in?
        flash[:success] = 'You are already signed in, goof!'
        redirect_to root_path
      end
    end

    # Before filters

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
end
