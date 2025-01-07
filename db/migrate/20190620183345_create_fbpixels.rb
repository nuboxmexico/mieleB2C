class CreateFbpixels < ActiveRecord::Migration
  def change
    create_table :fbpixels do |t|
      t.string :pixel_id
      t.boolean :active
      t.boolean :search
      t.boolean :view_content
      t.boolean :add_to_cart
      t.boolean :initiate_checkout
      t.boolean :add_payment_info
      t.boolean :purchase
      t.boolean :lead_client
      t.boolean :complete_registration

      t.timestamps null: false
    end
  end
end
