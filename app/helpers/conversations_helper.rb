module ConversationsHelper

  def tokenfield_source
    source = []
    current_user.followed_users.each do |u|
      source << { value: u.email, label: u.name, profile_picture: raw(avatar_for u, { size: :small, class: 'media-object' }) }
    end
    raw(source.to_json)
  end

end
