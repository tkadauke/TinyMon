class DeselectCheckBoxStep < Step
  data_attribute :name
  
  include Formotion::Formable
  
  form_property :name, :string
  
  def summary
    "Deselect check box"
  end
  
  def detail
    "with name '#{name}'"
  end
end
