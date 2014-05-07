class AttendancesController < ApplicationController
  before_action :signed_in_user

  def create
    @dropin = Dropin.find(params[:attendance][:dropin_id])
    current_user.join_dropin!(@dropin)
    respond_to do |format|
      format.html { redirect_to @dropin }
      format.js
    end
  end

  def destroy
    @dropin = Attendance.find(params[:id]).dropin
    current_user.leave_dropin!(@dropin)
    respond_to do |format|
      format.html { redirect_to @dropin }
      format.js
    end
  end
end
