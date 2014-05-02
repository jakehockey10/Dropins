class ContactsController < ApplicationController
  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)
    @contact.email_token = Contact.encrypt(Contact.new_token)
    @contact.request = request
    if @contact.deliver
      flash.now[:success] = 'Thank you for your message. We will contact you soon!'
      respond_to do |format|
        format.js
      end
    else
      flash.now[:danger] = 'Cannot send message.'
      render :new
    end
  end

  private
    def contact_params
      params.require(:contact).permit(:email, :language, :nickname)
    end
end