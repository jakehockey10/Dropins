class RinksController < ApplicationController
  before_action :set_rink, only: [:show, :edit, :update, :destroy]
  #
  # def search
  #   Gmaps4rails.places_for_address('Denver, CO', ENV['MAPS_API_KEY'], params[:search])
  #   respond_to do |format|
  #     format.js
  #   end
  # end

  # GET /rinks
  # GET /rinks.json
  def index
    @rinks = Rink.all
    @rink = Rink.new
    @hash = Gmaps4rails.build_markers(@rinks) do |rink, marker|
      marker.lat rink.latitude
      marker.lng rink.longitude
      marker.title rink.name
    end
  end

  # GET /rinks/1
  # GET /rinks/1.json
  def show
  end

  # GET /rinks/new
  def new
    @rink = Rink.new
  end

  # POST /rinks
  # POST /rinks.json
  def create
    @rink = Rink.new(rink_params)
    @rinks = Rink.all

    respond_to do |format|
      if @rink.save
        format.html { flash[:success] = 'Rink was successfully created.'; redirect_to rinks_url }
        format.json { render :show, status: :created, location: @rink }
      else
        format.html { render 'rinks/index' }
        format.json { render json: @rink.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rinks/1
  # PATCH/PUT /rinks/1.json
  def update
    respond_to do |format|
      if @rink.update(rink_params)
        format.html { flash[:success] = 'Rink was successfully updated.'; redirect_to @rink }
        format.json { render :show, status: :ok, location: @rink }
      else
        format.html { render :edit }
        format.json { render json: @rink.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rinks/1
  # DELETE /rinks/1.json
  def destroy
    @rink.destroy
    respond_to do |format|
      format.html { flash[:success] = 'Rink was successfully destroyed.'; redirect_to rinks_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rink
      @rink = Rink.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def rink_params
      params.require(:rink).permit(:latitude, :longitude, :address, :name)
    end
end
