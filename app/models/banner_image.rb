class BannerImage < ActiveRecord::Base
	has_attached_file :image, styles: {large: "1920x1200",medium: "300x300", thumb: "100x100" }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
end
