module DropinsHelper
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
