class AddUniqueToEmailNewsletterSubscribers < ActiveRecord::Migration
  def change
  	add_index :newsletter_subscribers, :email, :unique => true
  end
end
