source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.8'
# Use mysql as the database for Active Record
#gem 'mysql2', '>= 0.3.13', '< 0.5'
gem 'pg', '~> 0.18.4'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
#gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc
# Icons from awesome fonts
gem "font-awesome-rails"
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'
gem 'sprockets'
# Use Unicorn as the app server
# gem 'unicorn'
#Gema para ejecuar jobs de manera Conologica.
gem 'whenever'
# Spreecomerce gems
gem 'spree', '~> 3.1.12'
gem 'spree_auth_devise', '~> 3.3'
gem 'spree_gateway', '~> 3.3'
gem 'spree_related_products', github: 'spree-contrib/spree_related_products'
gem 'spree_recently_viewed', github: 'spree-contrib/spree_recently_viewed', branch: '3-1-stable'
gem 'spree_i18n', github: 'spree/spree_i18n'
gem 'spree_reviews', github: 'spree-contrib/spree_reviews'
gem 'spree_editor', github: 'spree-contrib/spree_editor'
gem 'tinymce-rails-langs'
gem "spree_product_zoom", :git => "git://github.com/spree/spree_product_zoom.git"
gem 'spree_sitemap', github: 'spree-contrib/spree_sitemap'      
gem "cocaine"
#Gema para leer y escribir archivos Excel y CSV
gem 'roo'
gem 'fastimage'
#Integración webpay
gem 'signer', '~> 1.4.2'
gem 'savon', '~> 2.11.1'

# Active record query
gem "squeel"

gem 'awesome_print' , '2.0.0.pre2'

# HTTP Requests
gem 'faraday'
gem 'mimemagic', '0.3.0', github: 'mimemagicrb/mimemagic', ref: 'a4b038c6c1b9d76dac33d5711d28aaa9b4c42c66'
##############################################
#### Gema de integración con mercado pago
gem "mercadopago-sdk"
##############################################
gem 'ahoy_matey'
##############################################
gem 'will_paginate', '~> 3.1.0'
gem 'will_paginate-bootstrap'
##############################################
# PDF Generador
gem 'wicked_pdf'
# HTML to PDF
gem 'wkhtmltopdf-binary' 
##############################################
# Integración de ROR con React js
gem 'react-rails'
##############################################
# Para detección de errores y envio de correos
gem 'exception_notification'
##############################################
## Gema para agregar captcha google a los formularios
gem "recaptcha", require: "recaptcha/rails"
## descarga de excel
gem "rubyzip"
gem 'axlsx', git: 'https://github.com/randym/axlsx.git', ref: 'c8ac844'
gem 'axlsx_rails'

gem "spree_comments", github: 'spree-contrib/spree_comments'

gem 'rack-attack'
gem 'invisible_captcha'

gem 'inline_svg'
gem 'gaffe'

gem 'friendly_id'

# Log de eventos a nivel de DB
gem 'paper_trail'

## Gema de amazon para hacer conexión con S3 en la subida de imágenes
gem 'aws-sdk', '< 2.0'
gem 'aws-sdk-s3'

## Gema para la sincronización de los assets con amazon
gem 'asset_sync'
gem 'fog-aws'

gem 'momentjs-rails'
gem 'bootstrap3-datetimepicker-rails', '~> 4.14.30'


## Gema para detectar el browser
gem "browser", "~> 2.0.1"
# Gema para realizar un soft-delete
gem "paranoia", "~> 2.1.5"

# Gema para manejar archivos CSV
gem "csv"

# SDK de Transbank para la integración de Webpay Plus
gem 'transbank-sdk'

#Email

gem 'mandrill-api', require:'mandrill'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
##############################################
# PDF Generador
gem 'wicked_pdf'
# HTML to PDF
gem 'wkhtmltopdf-binary' 
##############################################
  # Variables de entorno en development
  gem 'dotenv-rails'

  # Capistrano para despliegue de aplicación en servidor remoto
  gem 'capistrano', '~> 3.0'
  gem 'capistrano-rvm'
  gem 'capistrano-bundler', '1.1.1'
  gem 'capistrano-rails', '1.1.3'
end

group :development, :test do
    gem 'rspec-rails', '~> 3.7'
    gem 'capybara'
    gem 'rspec-json_expectations'
    gem 'shoulda-matchers', '~> 3.1'
    gem 'factory_bot_rails'
    
    # sudo apt-get install qt5-default libqt5webkit5-dev gstreamer1.0-plugins-base gstreamer1.0-tools gstreamer1.0-x
    gem 'capybara-webkit'
    
    gem 'database_cleaner'

     # Análisis estático para detección de vulnerabilidades de seguridad (fuente: https://github.com/presidentbeef/brakeman)
    gem 'brakeman', require: false

    # Análisis de cobertura de test
    gem 'simplecov', require: false

    # Code quality reporter
    gem "rubycritic", require: false

    # Trigger Rubycritic each a time file is saved
    gem "guard-rubycritic", require: false
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

gem "pagy", "~> 3.14"
