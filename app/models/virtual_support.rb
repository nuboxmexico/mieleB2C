class VirtualSupport < ActiveRecord::Base
  has_attached_file :background_image
  validates_attachment_content_type :background_image, content_type: /\Aimage\/.*\Z/

  def self.show?
    virtual_support = VirtualSupport.first
    return (virtual_support and virtual_support.active and virtual_support.url.present?)
  end
end
