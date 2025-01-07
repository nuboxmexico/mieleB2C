# Configure Spree Preferences
#
# Note: Initializing preferences available within the Admin will overwrite any changes that were made through the user interface when you restart.
#       If you would like users to be able to update a setting with the Admin it should NOT be set here.
#
# Note: If a preference is set here it will be stored within the cache & database upon initialization.
#       Just removing an entry from this initializer will not make the preference value go away.
#       Instead you must either set a new value or remove entry, clear cache, and remove database entry.
#
# In order to initialize a setting do:
# config.setting_name = 'new value'
require 'spree/product_filters'

Spree.config do |config|
  # Example:
  # Uncomment to stop tracking inventory levels in the application
  # config.track_inventory_levels = false
  config.currency = 'CLP'
end

Spree.user_class = "Spree::User"
Spree.config do |config|
  config.products_per_page = 15
  config.allow_guest_checkout = true

  begin
  	country = Spree::Country.find_by(name: 'Chile')
  rescue
  	country = nil
  end
  config.default_country_id = country.id if country.present?

end

Rails.application.config.to_prepare do
  Spree::Order.whitelisted_ransackable_attributes |= %w[miele_state]
end

Rails.application.config.spree.payment_methods << Spree::Gateway::WebpayGateway
Spree::PermittedAttributes.user_attributes.push :name, :last_name, :rut

Spree::PermittedAttributes.address_attributes.push :comuna_id
Spree::PermittedAttributes.address_attributes.push :complementary_data
Spree::PermittedAttributes.address_attributes.push :rut
Spree::PermittedAttributes.address_attributes.push :street_type
Spree::PermittedAttributes.address_attributes.push :number
Spree::PermittedAttributes.address_attributes.push :apartment

Spree::ProductZoom::Config[:default_image_style] = :large

Spree::PermittedAttributes.taxon_attributes.push :featured

Spree::PermittedAttributes.product_attributes.push :featured
Spree::PermittedAttributes.product_attributes.push :offer_price
Spree::PermittedAttributes.product_attributes.push :offer_price_start
Spree::PermittedAttributes.product_attributes.push :offer_price_end
Spree::PermittedAttributes.product_attributes.push :long_description
Spree::PermittedAttributes.product_attributes.push :service

Spree::PermittedAttributes.shipment_attributes.push :alternative_tracking

Spree::PermittedAttributes.store_attributes.push :show_newsletter_popup

Spree::Ability.register_ability(AbilityDecorator)

# Mensaje de Jano jaja
# Descomentar cuando pasen esas funciones a producción.
# Estas líneas se me pasaron en un merge y no me dí cuenta :me-perdonas:
# Rails.application.config.spree.promotions.rules << Spree::Promotion::Rules::MielePolicy
# Rails.application.config.spree.promotions.actions << Spree::Promotion::Actions::MieleAdjustment

if Rails.env.production?
  attachment_config = {

    s3_credentials: Rails.application.secrets['aws']['s3_credentials'],

    storage:        :s3,
    #s3_host_name: "s3-us-east-1.amazonaws.com",
    s3_region:      "us-east-1",
    s3_headers:     { "Cache-Control" => "max-age=31557600" },
    s3_protocol:    "https",
    bucket:         "mieleb2c-cl",
    url: ':s3_alias_url',
    s3_host_alias: "d146vbe2nx0i1o.cloudfront.net",
    styles: {
        mini:     "48x48>",
        small:    "100x100>",
        product:  "240x240>",
        large:    "600x600>"
    },

    path:           "/:class/:id/:style/:basename.:extension",
    default_url:    "/:class/:id/:style/:basename.:extension",
    default_style:  "product"
  }

  
  attachment_config.each do |key, value|
    Spree::Image.attachment_definitions[:attachment][key.to_sym] = value
  end
end
