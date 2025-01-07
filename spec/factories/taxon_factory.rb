FactoryBot.define do
  factory :taxon, class: Spree::Taxon do
    sequence(:name) { |n| "taxon_#{n}" }
    taxonomy
    parent_id { taxonomy.root.id }

    factory :taxon_with_banner do 
      after :create do |taxon|
        create(:promotional_banner, taxon: taxon)
      end
    end
  end
end