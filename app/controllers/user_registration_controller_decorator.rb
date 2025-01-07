module Spree
  UserRegistrationsController.class_eval do
    layout '/spree/layouts/user_layout', only: :new
  end
end