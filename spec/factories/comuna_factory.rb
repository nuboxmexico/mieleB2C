FactoryBot.define do
	factory :comuna do
		name {"Santiago"}
		province{Province.first}
	end
end