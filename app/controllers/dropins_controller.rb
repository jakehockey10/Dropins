class DropinsController < ApplicationController
  before_action :signed_in_user
  before_action :set_dropin, only: [:show, :edit, :update, :destroy]
  before_action :admin_user, only: [:edit, :update, :new, :create, :destroy]

  def index
    @dropins = Dropin.all
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
    @dropin = Dropin.new(dropin_params)

    if @dropin.save
      flash[:success] = 'Dropin was successfully created.'
      redirect_to @dropin
    else
      render 'new'
    end
  end

  def update
    if @dropin.update(dropin_params)
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
      params.require(:dropin).permit(:date)
    end
end
