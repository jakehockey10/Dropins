class DropinsController < ApplicationController
  before_action :signed_in_user
  before_action :set_dropin, only: [:show, :edit, :update, :destroy]
  before_action :admin_user, only: [:edit, :update, :new, :create, :destroy]

  def index
    @dropins = Dropin.order('date asc').paginate(page: params[:page], per_page: 8)
  end

  def show
    @skaters = @dropin.skaters.paginate(page: params[:page])
  end

  def new
    @dropin = Dropin.new
  end

  def edit
    # TODO: Do a flash message if error occurs.
  end

  def create
    the_dropin_params = dropin_params
    the_dropin_params[:date] = Time.strptime(the_dropin_params[:date], '%m/%d/%Y %I:%M %p')
    @dropin = Dropin.new(the_dropin_params)
    @dropin.user = current_user

    if @dropin.save
      respond_to do |format|
        format.html do
          flash[:success] = 'Dropin was successfully created.'
          redirect_to @dropin
        end
        format.js
      end
    else
      render 'new'
    end
  end

  def update
    the_dropin_params = dropin_params
    the_dropin_params[:date] = Time.strptime(the_dropin_params[:date], '%m/%d/%Y %I:%M %p')
    if @dropin.update(the_dropin_params)
      flash[:success] = 'Dropin was successfully updated.'
      redirect_to @dropin
    else
      render 'edit'
    end
  end

  def destroy
    @dropin.destroy
    flash[:success] = 'Dropin was successfully destroyed.'
    redirect_to dropins_url
  end

  # GET /dropins/pay/1
  def pay
    redirect_uri = url_for(controller: 'dropins', action: 'payment_success', user_id: params[:user_id], host: request.host_with_port)
    @dropin = Dropin.find(params[:id])
    @user = User.find(@dropin.user.id)
    begin
      @checkout = @user.create_checkout(redirect_uri, @dropin.price)
    rescue Exception => e
      @checkout = e.message
    end
    respond_to do |format|
      format.js
    end
  end

  #GET /dropins/payment_success/1
  def payment_success
    @dropin = Dropin.find(params[:id])
    unless params[:checkout_id]
      flash[:danger] = 'Error - Checkout ID is expected'
      return redirect_to @dropin
    end
    if params['error'] && params['error_description']
      flash[:danger] = "Error - #{params['error_description']}"
      return redirect_to @dropin
    end
    flash[:success] = 'Thanks for the payment!  You should receive a confirmation email shortly.'
    current_user.commit_to!(@dropin)
    redirect_to @dropin
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dropin
      @dropin = Dropin.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def dropin_params
      params.require(:dropin).permit(:date, :price, :rink_id, :user_id)
    end
end
