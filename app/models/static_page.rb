class StaticPage < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged
  has_attached_file :background_image, styles: {large: "1920x1200",medium: "300x300", thumb: "100x100" }
  validates_attachment_content_type :background_image, content_type: /\Aimage\/.*\Z/
end
