Spree::Address.class_eval do
  validates_presence_of :comuna_id
  before_validation :check_address
  belongs_to :comuna

  enum street_type: [:street, :alley, :avenue]

  def check_address
  	if self.comuna_id.nil?
  		self.comuna_id = comuna_id
  	end
  	true
  end

  def user_full_name
    return "#{self.firstname} #{self.lastname}"
  end

  def street_type_translation
    return Spree::Address.street_types[self.street_type]
  end

  def self.street_types
    return {
      'street' => 'Calle',
      'alley' => 'Pasaje',
      'avenue' => 'Avenida'
    }
  end

  def data_to_core(core_name = nil)
    return {
      name: core_name,
      country_id: "2", 
      state: self.comuna.try(:core_id).to_s,
      street_type: self.street_type_translation.to_s,
      street_name: self.address1.to_s,
      cellphone: self.phone.to_s,
      phone: self.phone.to_s,
      ext_number: self.number,
      int_number: self.apartment,
      reference: self.complementary_data
    }
  end

  def billing_data
    return {
      state_fn: self.comuna.try(:core_id).to_s,
      street_type_fn: self.street_type_translation.to_s,
      street_name_fn: self.address1.to_s,
      phone_fn: self.phone.to_s,
      ext_number_fn: self.number,
      int_number_fn: self.apartment
    }
  end

  def full_address
    return "#{self.address1} #{self.number}, #{self.apartment}"
  end

end