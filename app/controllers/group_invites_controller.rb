class GroupInvitesController < ApplicationController

  def create
    group_invite_params[:followers].split(/\s*,\s*/)
  end

  private

  def group_invite_params
    params.require(:group_invite).permit(:followers)
  end

end
