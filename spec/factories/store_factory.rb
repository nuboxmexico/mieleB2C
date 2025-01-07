FactoryBot.define do
  factory :store, class: Spree::Store do
    sequence(:code) { |i| "spree_#{i}" }
    name {'GarageLabs Tienda de Prueba'}
    url {'www.garagelabs.cl'}
    mail_from_address {'spree@example.org'}
    default_currency {'CLP'}
    default {true}
  end
end