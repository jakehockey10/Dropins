require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module DropinsApp
  class Application < Rails::Application

    config.assets.paths << Rails.root.join('vendor', 'assets', 'components')

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Mountain Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    config.assets.precompile += %w( *.png *.jpg *.jpeg *.gif )

    # # We don't want the default of everything that isn't js or css, because it pulls too many things in
    # config.assets.precompile.shift
    #
    # # Explicitly register the extensions we are interested in compiling
    # config.assets.precompile.push(Proc.new do |path|
    #   File.extname(path).in? [
    #     '.html', '.erb', '.haml',                 # Templates
    #     '.png',  '.gif', '.jpg', '.jpeg', '.svg', # Images
    #     '.eot',  '.otf', '.svc', '.woff', '.ttf', # Fonts
    #   ]
    #   end)
    config.serve_static_files = true

    I18n.enforce_available_locales = true

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    # Include the authenticity token in remote forms.
    config.action_view.embed_authenticity_token_in_remote_forms = true
  end
end
