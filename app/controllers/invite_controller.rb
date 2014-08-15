class InviteController < ApplicationController
  # def import
  #   begin
  #     @sites = { 'Gmail' => Contacts::Gmail, 'Yahoo' => Contacts::Yahoo, 'Hotmail' => Contacts::Hotmail }
  #     @contacts = @sites[invite_params[:from]].new(invite_params[:login], invite_params[:password]).contacts
  #     @users = []
  #     @contacts.each do |contact|
  #       @users << { name: contact[0], email: contact[1] }
  #     end
  #   end
  #   respond_to do |format|
  #     format.js
  #   end
  # end

  def invite
    UserMailer.invite_users_to_dropin(current_user.id,
                                      invite_params[:users],
                                      invite_params[:dropin_id],
                                      invite_params[:message]).deliver
    flash[:success] = 'Invitations sent!'
    redirect_to dropin_url(invite_params[:dropin_id])
  end

  def oauth2callback
    @contacts = request.env['omnicontacts.contacts']
    @user = request.env['omnicontacts.user']
    puts "List of contacts of #{user[:name]} obtained from #{params[:importer]}:"
    @contacts.each do |contact|
      puts "Contact found: name => #{contact[:name]}, email => #{contact[:email]}"
    end
    respond_to do |format|
      format.js
    end
  end

  def failure

  end

  private

  def invite_params
    params.permit(:from, :login, :password, :users, :dropin_id, :message)
  end
end
