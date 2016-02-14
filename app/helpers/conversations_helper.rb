module ConversationsHelper

  def tokenfield_source(user)
    source = []
    user.following.each do |u|
      source << { value: u.email, label: u.name, profile_picture: raw(avatar_for u, { size: :small, class: 'media-object' }) }
    end
    raw(source.to_json)
  end

end
