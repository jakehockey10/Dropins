module UsersHelper

  # Returns the Gravatar (http://gravatar.com/) for the given user.
  def gravatar_for(user, options = { size: 50, border: false })
    gravatar_url = user.gravatar_url(options)
    if options[:border]
      gravatar_class = 'img-circle img-thumbnail'
    else
      gravatar_class = 'img-circle'
    end
    image_tag(gravatar_url, alt: user.name, class: gravatar_class)
  end
end