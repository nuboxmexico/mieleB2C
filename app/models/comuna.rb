class Comuna < ActiveRecord::Base
  belongs_to :province

  def self.get_comunas_by_region(region_id)
  	comunas = Comuna.joins(:province).where('provinces.spree_state_id = ?', region_id).order(:name).map {|comuna| [comuna.id, comuna.name]}
    return comunas  
  end

  def self.update_core_id
    if (response = MieleCoreApi.get_administrative_demarcations)
      response['data'].each do |data| 
        if (comuna = Comuna.find_by(name: data['admin_name_3']))
          comuna.update(core_id: data['id'])
        end
      end
    end
  end
end
