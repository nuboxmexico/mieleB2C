module VirtualSupportHelper

  def background_image
    if @virtual_support.background_image.present?
      return "background: linear-gradient(rgba(0,0,0,.5), rgba(0,0,0,.5)), 
           url('#{asset_path @virtual_support.background_image}'); background-size: cover!important;"
    end
  end
end
