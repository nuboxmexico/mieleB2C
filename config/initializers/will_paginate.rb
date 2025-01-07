if defined?(WillPaginate)
  module WillPaginate
    module ActiveRecord
      module RelationMethods
        alias_method :per, :per_page
        alias_method :num_pages, :total_pages
        alias_method :total_count, :total_entries
        def per(value = nil) per_page(value) end
        def total_count() count end
      end
      module CollectionMethods
      	def total_entries
	        @total_entries ||= begin
	          if loaded? and size.to_i < limit_value.to_i and (current_page == 1 or size.to_i > 0)
	            offset_value + size
	          else
	            @total_entries_queried = true
	            result = count
	            result = result.size if result.respond_to?(:size) and !result.is_a?(Integer)
	            result
	          end
	        end
		    end
      end
    end
  end
end
