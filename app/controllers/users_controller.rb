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
      flash[:success] = 'Welcome to Rosenbridge Beta!  Please verify the email you provided by clicking the link we sent to you.'
      redirect_to @user
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

  private

    def user_params
      params.require(:user).permit(:name,
                                   :email,
                                   :speaking_language,
                                   :learning_language,
                                   :password,
                                   :password_confirmation)
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

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
