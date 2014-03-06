class InterestedPersonController < ApplicationController
  def new
    @interested_person = InterestedPerson.new
  end

  def create
    @interested_person = InterestedPerson.new(interested_person_params)

    if @interested_person.save
      UserMailer.interested_person_welcome(@interested_person).deliver
      #flash[:success] = "Sweet!  We'll keep you posted on what's coming!"
    end

    respond_to do |format|
      format.js
    end
    #redirect_to root_path
  end

  def destroy
    @interested_person = InterestedPerson.find(params[:id])
    @interested_person.destroy
  end

  private

    def interested_person_params
      params.require(:interested_person).permit(:email)
    end
end
