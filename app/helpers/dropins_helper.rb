module DropinsHelper

  def current_user_is_owner
    current_user == @dropin.user
  end

  def current_user_can_invite_skaters
    @dropin.is_in_the_future? && @dropin.is_not_full && current_user.id == @dropin.user_id
  end

  def current_user_is_attending
    @dropin.is_in_the_future? && current_user.id != @dropin.user_id && @dropin.skaters.include?(current_user)
  end

  def skater_has_paid(skater_id, dropin_id)
    attendance = Attendance.where(user_id: skater_id, dropin_id: dropin_id)
    if attendance.first
      attendance.first.paid
    end
  end

  def show_remove_skater_from_dropin_button(skater_id, dropin_id)
    current_user && current_user.admin? && !skater_has_paid(dropin_id, skater_id)
  end

  def show_join_button(dropin, user_id)
    dropin.is_not_full && dropin.user_is_not_attending(user_id)
  end

  def followers_attending(dropin, user)
    result = ''
    followers_going = dropin.skaters.where(id: user.following)
    followers_going.each do |u|
      result << (link_to avatar_for(u, size: :small), u, data: { toggle: 'tooltip', placement: 'top', title: u.name })
    end
    if result == ''
      'none.'
    else
      result.html_safe
    end
  end
end
