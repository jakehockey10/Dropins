class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: [:destroy, :make_withdrawal]

  autocomplete :gmail_contact,
               :name,
               full: true,
               extra_data: [:email, :name, :profile_picture],
               display_value: :get_email_from_name

  def get_autocomplete_items(params)
    super(params).where(user_id: current_user.id)
  end

  def index
    @q = User.where(activated: true).ransack(params[:q])
    @users = @q.result.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
    redirect_to root_url and return unless @user.activated?
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = 'Welcome to Dropins Beta!  Please verify the email you provided by clicking the link we sent to you.'
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    if current_user.has_wepay_account?
      @withdrawal_counts = current_user.get_withdrawal_counts
      @account           = current_user.get_wepay_account
    end
  end

  def show_avatar
    respond_to do |format|
      format.js
    end
  end

  def upload_avatar
    respond_to do |format|
      format.js
    end
  end

  def delete_avatar
    user = User.find(params[:id])
    user.avatar.destroy
    user.save
    respond_to do |format|
      format.js
    end
  end

  def update
    @user = User.find(params[:id])
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
    @users = @user.following.paginate(page: params[:page])
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
    unless params[:code]
      return redirect_to root_path
    end

    redirect_uri = url_for(controller: 'users', action: 'oauth', user_id: params[:user_id], host: request.host_with_port)
    @user = User.find(params[:user_id])
    begin
      @user.request_wepay_access_token(params[:code], redirect_uri)
    rescue Exception => e
      error = e.message
    end

    error ? flash[:danger] = error : flash[:success] = 'We successfully connected you to WePay!'
    redirect_to edit_user_path @user
  end

  def make_withdrawal

    redirect_uri = url_for(controller: 'users', action: 'edit', id: params[:user_id], host: request.host_with_port)
    @user = User.find(params[:user_id])
    begin
      @withdrawal = @user.make_withdrawal(redirect_uri)
    rescue Exception => e
      error = e.message
    end

    if error
      @error = error
    end

    respond_to do |format|
      format.js
    end
  end

  private

    def user_params
      params.require(:user).permit(:first_name,
                                   :second_name,
                                   :email,
                                   :password,
                                   :password_confirmation,
                                   :wepay_access_token,
                                   :wepay_account_id,
                                   :avatar)
    end

    # Before filters

    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
end
