module DropinsHelper
  def show_join_button(dropin, user_id)
    dropin.is_not_full && dropin.user_is_not_attending(user_id)
  end
end
