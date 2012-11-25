class SelectCheckBoxStep < Step
  data_attribute :name
  
  include Formotion::Formable
  
  form_property :name, :string
  
  def summary
    "Select check box"
  end
  
  def detail
    "with name '#{name}'"
  end
end
