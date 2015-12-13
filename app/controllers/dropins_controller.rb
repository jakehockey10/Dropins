class DropinsController < ApplicationController
  require 'will_paginate/array'

  before_filter :set_dropins, only: [:index, :create]
  before_action :logged_in_user
  before_action :set_dropin, only: [:show, :edit, :update, :destroy, :email_attendees]
  before_action :admin_user, only: [:edit, :update, :new, :create, :destroy]
  before_action :set_contacts, only: [:show]

  def index
  end

  def show
    @skaters                        = @dropin.skaters.paginate(page: params[:page])
    @gmail_contacts, @user_contacts = @dropin.user.gmail_contacts.partition { |contact| contact.other_user_id == 0 }
  end

  def new
    @dropin = Dropin.new
  end

  def edit
    # TODO: Do a flash message if error occurs.
  end

  def create
    the_dropin_params = dropin_params
    the_dropin_params[:date] = Time.strptime(the_dropin_params[:date], '%m/%d/%Y %I:%M %p') rescue the_dropin_params[:date]
    @dropin      = Dropin.new(the_dropin_params)
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
      respond_to do |format|
        format.js
      end
    end
  end

  def update
    the_dropin_params = dropin_params
    unless the_dropin_params[:date].empty?
      the_dropin_params[:date] = Time.strptime(the_dropin_params[:date], '%m/%d/%Y %I:%M %p')
    end
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

  def pay
    redirect_uri = url_for(controller: 'dropins', action: 'payment_success', user_id: params[:user_id], host: request.host_with_port)
    @dropin      = Dropin.find(params[:id])
    @user        = User.find(@dropin.user.id)
    begin
      @checkout = @user.create_checkout(redirect_uri, @dropin.price)
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
    current_user.join_dropin!(@dropin)
    attendance = Attendance.where(user_id: current_user, dropin_id: @dropin.id).first
    attendance.update(paid: true) if attendance
    redirect_to @dropin
  end

  def email_attendees
    DropinAttendeeMailer.email_attendees(current_user.id,
                                         @dropin.skaters.pluck(:email),
                                         @dropin.id,
                                         params[:subject],
                                         params[:message]).deliver
    flash[:success] = 'Emails sent!'
    redirect_to @dropin
  end

  private

  # Scope dropins index page using current_user
  def set_dropins
    @dropins              = Dropin.all
    @current_user_dropins = (current_user.dropins + Dropin.where(user_id: current_user.id)).sort_by { |d| d[:date] }.paginate(page: params[:page], per_page: 8)
    @public_dropins       = Dropin.select { |d| d.groups.count == 0 }.sort_by { |d| d[:date] }.paginate(page: params[:page], per_page: 8)
    @group_dropins        = Dropin.shares_any_group(current_user).sort_by { |d| d[:date] }.paginate(page: params[:page], per_page: 8)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_dropin
    @dropin = Dropin.find(params[:id])
  end

  def set_contacts
    @contacts = GmailContact.where(user_id: current_user.id)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def dropin_params
    params.require(:dropin).permit(:date, :price, :rink_id, :user_id, :limit, :description)
  end
end
