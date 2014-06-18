class ReservationsController < ApplicationController
  def express_checkout
    @dropin = Dropin.find(params[:dropin_id])
    response = EXPRESS_GATEWAY.setup_purchase(@dropin.price * 100,
      ip: request.remote_ip,
      return_url: dropin_url(@dropin.id),
      cancel_return_url: dropin_url(@dropin.id),
      currency: 'USD',
      allow_guest_checkout: true,
      items: [{name: 'Reservation', description: 'Reservation description', quantity: '1', amount: @dropin.price * 100}])
    redirect_to EXPRESS_GATEWAY.redirect_url_for(response.token)
  end

  def new
    @reservation = Reservation.new(express_token: params[:token])
  end

  def create
    @dropin = Dropin.find(params[:dropin_id])
    @reservation = @dropin.build_reservation(reservation_params)
    @reservation.ip = request.remote_ip

    if @reservation.save
      if @reservation.purchase
        redirect_to reservation_url(@reservation)
      else
        render action: 'failure'
      end
    else
      render action: 'new'
    end
  end

  private

    def reservation_params
      params.require(:reservation).permit(:dropin_id, :ip, :express_token, :express_payer_id)
    end
end
