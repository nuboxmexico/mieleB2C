module TaxonsHelper
  def taxon_tree
    taxon_tree = []
    taxon = @taxon
    while taxon
      taxon_tree << taxon
      taxon = taxon.parent
    end
    return taxon_tree.reverse
  end

  def taxon_banner
    if @taxon.banner
      return "background: linear-gradient(rgba(0,0,0,.5), rgba(0,0,0,.5)), 
           url('#{asset_path @taxon.banner.image.url(:large)}'); background-size: cover!important;"
    else
      taxon = @taxon.parent
      while taxon
        if taxon.banner
          return "background: linear-gradient(rgba(0,0,0,.5), rgba(0,0,0,.5)), 
                  url('#{asset_path taxon.banner.image.url(:large)}'); background-size: cover!important;"  
        end
        taxon = taxon.parent
      end
    end
  end
end