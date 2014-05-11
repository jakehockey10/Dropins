class RinksController < ApplicationController
  before_action :signed_in_user
  before_action :set_rink, only: [:show, :edit, :update, :destroy]
  before_action :admin_user, only: [:edit, :update, :new, :create, :destroy]

  def index
    @rinks = Rink.all
  end

  def show
  end

  def new
    @rink = Rink.new
  end

  def edit
  end

  def create
    @rink = Rink.new(rink_params)
    if @rink.save
      flash[:success] = 'Rink was successfully created.'
      redirect_to @rink
    else
      render 'new'
    end
  end

  def update
    if @rink.update(dropin_params)
      flash[:success] = 'Rink was successfully updated.'
      redirect_to @rink
    else
      render 'edit'
    end
  end

  def destroy
    @rink.destroy
    flash[:success] = 'Rink was successfully destroyed.'
    redirect_to rinks_url
  end

  private

    def rink_params
      params.require(:rink).permit(:name, :address)
    end

    def set_rink
      @rink = Rink.find(params[:id])
    end
end
