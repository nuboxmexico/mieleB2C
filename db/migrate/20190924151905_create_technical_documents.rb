class CreateTechnicalDocuments < ActiveRecord::Migration
	def change
		create_table :technical_documents do |t|
			t.string :document_file_name
			t.string :document_content_type
			t.integer :document_file_size
			t.string :document_type
			t.datetime :document_updated_at
			t.references :spree_product, index: true, foreign_key: true

			t.timestamps null: false
		end
	end
end
