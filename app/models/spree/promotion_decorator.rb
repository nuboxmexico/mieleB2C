Spree::Promotion.class_eval do

	def total_ajust
		sum = 0
		self.orders.each do |order|
			sum = sum + order.all_adjustments.sum(:amount)
		end
		return sum
	end
end