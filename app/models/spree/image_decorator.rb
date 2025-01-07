Spree::Image.class_eval do

	def large_url
      attachment.url(:large, false)
    end
    def small_url
      attachment.url(:small, false)
    end
end