class ChooseRadioButtonStep < Step
  data_attribute :name
  
  include Formotion::Formable
  
  form_property :name, :string
  
  def self.attributes
    superclass.attributes
  end
  
  def summary
    "Choose radio button"
  end
  
  def detail
    "with name '#{name}'"
  end
end
