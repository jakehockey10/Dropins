class DropinsController < ApplicationController
  before_action :signed_in_user
  before_action :set_dropin, only: [:show, :edit, :update, :destroy]
  before_action :admin_user, only: [:edit, :update, :new, :create, :destroy]

  def index
    @dropins = Dropin.paginate(page: params[:page], per_page: 8, order: 'date asc')
  end

  def show
    @skaters = @dropin.skaters.paginate(page: params[:page])
  end

  def new
    @dropin = Dropin.new
  end

  def edit
  end

  def create
    the_dropin_params = dropin_params
    the_dropin_params[:date] = Time.strptime(the_dropin_params[:date], '%m/%d/%Y %I:%M %p')
    @dropin = Dropin.new(the_dropin_params)

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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dropin
      @dropin = Dropin.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def dropin_params
      params.require(:dropin).permit(:date, :price, :rink_id)
    end
end
