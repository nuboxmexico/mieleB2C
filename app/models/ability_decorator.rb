class AbilityDecorator
  include CanCan::Ability
  def initialize(user)
    if user.respond_to?(:has_spree_role?) && user.has_spree_role?('Vendedor')
      can [:admin, :manage], Spree::Order
      can [:admin, :manage], Spree::LineItem
      can [:admin, :manage], Spree::Shipment
      can [:admin, :manage], Spree::Address
      can [:edit], Spree::user_class
      can [:admin, :manage], Spree::Payment
      can [:admin, :manage], Spree::Comment
      can [:admin, :manage], Spree::StateChange
    end
  end
end

Spree::Ability.register_ability(AbilityDecorator) 