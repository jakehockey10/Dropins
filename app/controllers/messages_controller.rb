class MessagesController < ApplicationController
  before_filter :signed_in_user

  def index
    @messages = current_user.received_messages
  end

  def create

    message = Message.new(params[:message])
    message.sender_id = current_user.id
    if message.save
      flash[:success] = 'you created a message'
      redirect_to root_path

      # Send a Pusher notification
      Pusher['private-'+params[:message][:recipient_id]].trigger('new_message', {from: current_user.name, subject: message.subject})
    else
      @user = User.find(params[:message][:recipient_id])
      render action: 'users/show'
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_params
      params.require(:message).permit(:subject, :body, :recipient_id, :recipient_ids, :sender_id)
    end
end