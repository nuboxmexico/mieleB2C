class AddBackgroundImageToVirtualSupport < ActiveRecord::Migration
  def up
    add_attachment :virtual_supports, :background_image
  end

  def down
    remove_attachment :virtual_supports, :background_image
  end
end
