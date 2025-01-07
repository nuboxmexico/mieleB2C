FactoryBot.define do	
	sequence :user_authentication_token do |n|
  	"xxxx#{Time.current.to_i}#{rand(1000)}#{n}xxxxxxxxxxxxx"
	end

	factory :user, class: Spree.user_class do
    email { "oferusat@gmail.com" }
    rut {'1-1'}
    login { email }
    password {'password123'}
    password_confirmation { password }
    authentication_token { generate(:user_authentication_token) } if Spree.user_class.attribute_method? :authentication_token

    factory :admin_user do
      spree_roles { [Spree::Role.find_by(name: 'admin') || create(:role, name: 'admin')] }
    end

    factory :client_user, class: Spree::User do
			email {"oferusat@gmail.com"}
			password {"password123"}
		end

  	factory :enterprise_user, class: Spree::User do
			email {"oferusat@gmail.com"}
			password {"password123"}
			created_erp {false}
			enterprise_role {"enter"}
		end

    factory :user_with_addresses, aliases: [:user_with_addreses] do
      ship_address
      bill_address
    end

    factory :user_with_comparator do 
      after :create do |user|
        user.comparators << create(:comparator)
      end
    end
	end
end