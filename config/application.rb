require File.expand_path('../boot', __FILE__)
require 'rails/generators'
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MieleB2C
  class Application < Rails::Application
    
    config.to_prepare do
      # Load application's model / class decorators
      Dir.glob(File.join(File.dirname(__FILE__), "../app/**/*_decorator*.rb")) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end

      # Load application's view overrides
      Dir.glob(File.join(File.dirname(__FILE__), "../app/overrides/*.rb")) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    config.middleware.use Rack::Attack

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'
    config.time_zone = 'America/Santiago'
    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    config.i18n.default_locale = 'es-CL'
    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true
    config.exceptions_app = self.routes

    # File.open('config/version', 'w') do |file|
    #   file.write `git describe --abbrev=0 --tags` 
    # end
    config.version = File.read('config/version')


    if Rails.env.production?
      config.paperclip_defaults = {
        storage: :s3,
        #s3_host_name: 's3-us-east-1.amazonaws.com',
        s3_headers: { "Cache-Control" => "max-age=31557600" },
        s3_protocol: "https",
        :url => ':s3_alias_url',
        :s3_host_alias => "d146vbe2nx0i1o.cloudfront.net",
        :path =>  "/:class/:attachment/:id_partition/:style/:filename",
        s3_credentials: Rails.application.secrets['aws']['s3_credentials'],
        bucket: 'mieleb2c-cl'
      }
    end

    initializer 'spree.register.calculators' do |app|
      app.config.spree.calculators.shipping_methods << Spree::Calculator::Shipping::MieleCalculator
      app.config.spree.calculators.shipping_methods << Spree::Calculator::Shipping::MieleDispatchAndInstallationCalculator
      app.config.spree.calculators.shipping_methods << Spree::Calculator::Shipping::MielePromoCalculator
      app.config.spree.calculators.shipping_methods << Spree::Calculator::Shipping::MieleQuarantineCalculator
      app.config.spree.calculators.promotion_actions_create_adjustments << Spree::Calculator::MieleFlatPercentItemTotal
      app.config.spree.calculators.promotion_actions_create_adjustments << Spree::Calculator::MieleFlatPercentPerTaxon
    end
  end
end
