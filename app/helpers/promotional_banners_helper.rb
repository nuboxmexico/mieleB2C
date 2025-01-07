module PromotionalBannersHelper
  def category_banner_row(taxon)
    if taxon.banner
      link = link_to 'Editar banner', main_app.add_banner_to_category_path(taxon.id), class: 'btn btn-success btn-sm add-banner'
    else
      link = link_to 'Agregar banner', main_app.add_banner_to_category_path(taxon.id), class: 'btn btn-primary btn-sm add-banner'
    end
    return "<tr>
      <td class='category-depth-#{taxon.depth}'>#{taxon.name}</td>
      <td>
        #{image_tag taxon.banner.image.url(:thumb), class: 'category-banner' if taxon.banner}
      </td>
      <td>
        #{link}
      </td>
    </tr>".html_safe
  end
end
