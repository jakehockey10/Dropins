module UsersHelper

  def avatar_for(user, options = { size: :small, border: false, style: '', class: '' })
    if user.respond_to? :avatar
      if user.avatar.file?
        image_tag user.avatar.url(options[:size]), alt: user.name, class: image_class(options), style: options[:style]
      else
        unless options[:size]
          options[:size] = 250
        end
        if options[:size] == :small
          options[:size] = 60
        elsif options[:size] == :thumb
          options[:size] = 100
        elsif options[:size] == :medium
          options[:size] = 250
        elsif options[:size] == :large
          options[:size] = 500
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
    image_tag(gravatar_url, alt: user.name, class: image_class(options), style: options[:style])
  end

  def image_class(options)
    img_cls = 'img-circle'
    img_cls += ' img-thumbnail' if options[:border]
    img_cls += ' ' + options[:class] if options[:class]
    img_cls
  end
end