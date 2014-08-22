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
    # For now, only grab the contacts that have emails returned.
    @contacts = request.env['omnicontacts.contacts'].select { |contact| !contact[:email].nil? }
    @user = request.env['omnicontacts.user']
    dropin_id = request.env['rack.request.query_hash']['state']
    @contacts.each do |contact|
      gc = GmailContact.find_or_create_by(name: contact[:name],
                                         email: contact[:email],
                                         user_id: current_user.id,
                                         other_user_id: 0,
                                         profile_picture: contact[:profile_picture],
                                         phone_number: contact[:phone_number])
      gc.save unless gc.invalid?
    end

    flash[:success] = 'You have successfully imported your Gmail contacts!  You may use these in your invite forms from now on.'
    redirect_to dropin_url(dropin_id)
  end

  def failure

  end

  private

  def invite_params
    params.permit(:from, :login, :password, :dropin_id, :message, users: [])
  end
end
