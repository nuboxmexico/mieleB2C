Spree::LineItem.class_eval do
    after_save :check_installation

    private 
      def check_installation
        if self.instalation.nil?
          self.update_column(:instalation, false) rescue nil
        end
      end
end