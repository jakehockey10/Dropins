class ContactWithMessagesController < ApplicationController
  def new
    @contact_with_message = ContactWithMessage.new
  end

  def create
    @contact_with_message = ContactWithMessage.new(contact_with_message_params)
    @contact_with_message.request = request
    if @contact_with_message.deliver
      flash[:success] = 'Thank you for your message.  We will get back to you ASAP!'
      redirect_to root_url
    else
      flash.now[:danger] = 'Cannot send message'
      render :new
    end
  end

  private

    def contact_with_message_params
      params.require(:contact_with_message).permit(:name, :email, :message, :nickname)
    end
end
