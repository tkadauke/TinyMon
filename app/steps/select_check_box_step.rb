class SelectCheckBoxStep < Step
  data_attribute :name
  
  include Formotion::Formable
  
  form_property :name, :string
  
  def self.attributes
    superclass.attributes
  end
  
  def summary
    "Select check box"
  end
  
  def detail
    "with name '#{name}'"
  end
end
