object false
if !params[:ids].nil?
  if params[:ids].size > 0
  	@taxons = Spree::Taxon.includes(:children).accessible_by(current_ability, :read).where(id: params[:ids].split(',').map(&:to_i))
  else
  	@taxons = Spree::Taxon.includes(:children).accessible_by(current_ability, :read).order(:taxonomy_id, :lft).ransack(params[:q]).result
  end 
else
  @taxons = Spree::Taxon.includes(:children).accessible_by(current_ability, :read).order(:taxonomy_id, :lft).ransack(params[:q]).result
end
child @taxons => :taxons do
  attributes *taxon_attributes
  unless params[:without_children]
    extends "spree/api/v1/taxons/taxons"
  end
end
