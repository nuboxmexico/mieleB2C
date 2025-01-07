FactoryBot.define do
  factory :address, aliases: [:bill_address, :ship_address], class: Spree::Address do
    firstname {'John'}
    lastname {'Doe'}
    company {'Company'}
    address1 {'10 Lovely Street'}
    address2 {'Northwest'}
    city {'Herndon'}
    zipcode {'35005'}
    phone {'555-555-0199'}
    alternative_phone {'555-555-0199'}
    
    comuna {Comuna.first || create(:comuna)}
    state { |address| address.association(:state) || Spree::State.last }
    country{Spree::Country.last || create(:chile)}
  end
end