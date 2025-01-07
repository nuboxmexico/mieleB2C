class AddNewsletterPopupToSpreeStore < ActiveRecord::Migration
  def change
    add_column :spree_stores, :show_newsletter_popup, :boolean
  end
end
