class Tag < ActiveRecord::Base
	has_many :tags_products
  	has_many :products, :through => :tags_products

		def self.save_search_keyword(keyword)
			t = Tag.find_by(name: keyword)
			if t.nil?
				Tag.create(name: keyword, search_count: 1)
			else
				t.update(search_count: (t.search_count + 1))
			end
		end
end
