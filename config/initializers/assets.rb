# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path
Rails.application.config.assets.enabled = true
Rails.application.config.assets.paths << Rails.root.join("app", "assets", "fonts")

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
Rails.application.config.assets.precompile += %w( spree/backend/custom.css )
Rails.application.config.assets.precompile += %w( alertify.min.css )
Rails.application.config.assets.precompile += %w( alertify.min.js )
Rails.application.config.assets.precompile += %w( select2.min.js )
Rails.application.config.assets.precompile += %w( d3.min.js )
Rails.application.config.assets.precompile += %w( c3.min.js )
Rails.application.config.assets.precompile += %w( jquery.animateNumber.min.js )
Rails.application.config.assets.precompile += %w( sweetalert2.min.js )
Rails.application.config.assets.precompile += %w( sweetalert2.min.css )
Rails.application.config.assets.precompile += %w( application-admin.css )
Rails.application.config.assets.precompile += %w( application-admin.js )

