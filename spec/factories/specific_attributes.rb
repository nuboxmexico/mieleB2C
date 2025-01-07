FactoryBot.define do
  factory :specific_attribute do
    mandatory { false }
    channel { "MyString" }
    can_retire { false }
    can_ship { false }
    category { "MyString" }
    built_in { false }
    instalation { false }
    outlet { false }
    specs { "MyText" }
    features { "MyText" }
    technical_specs { "MyText" }
    product_functions { "MyText" }
    drink { "MyText" }
    basket_design { "MyText" }
    wash_program { "MyText" }
    dry_program { "MyText" }
    care { "MyText" }
    security { "MyText" }
    sustain { "MyText" }
    accessories { "MyText" }
    product { nil }
  end
end
