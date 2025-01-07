FactoryBot.define do
  factory :province do
    name {"Santiago"}

    after :create do |province|
      create(:comuna, province: province)
    end
  end
end