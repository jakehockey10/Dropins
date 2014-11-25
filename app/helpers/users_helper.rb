module UsersHelper

  def avatar_for(user, options = { size: :small, border: false })
    if user.respond_to? :avatar
      if user.avatar.file?
        image_tag user.avatar.url(options[:size]), alt: user.name, class: image_class(options[:border])
      else
        unless options[:size]
          options[:size] = 250
        end
        if options[:size] == :small
          options[:size] = 60
        end
        gravatar_for(user, options)
      end
    else
      image_tag 'Skates-small.jpg', alt: user.name, class: image_class(options[:border])
    end
  end

  # Returns the Gravatar (http://gravatar.com/) for the given user.
  def gravatar_for(user, options = { size: 50, border: false })
    gravatar_url = user.gravatar_url(options)
    image_tag(gravatar_url, alt: user.name, class: image_class(options[:border]))
  end

  def image_class(border)
    if border
      'img-circle img-thumbnail'
    else
      'img-circle'
    end
  end
end