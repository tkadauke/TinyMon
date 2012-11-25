class ChooseRadioButtonStep < Step
  data_attribute :name
  
  include Formotion::Formable
  
  form_property :name, :string
  
  def summary
    "Choose radio button"
  end
  
  def detail
    "with name '#{name}'"
  end
end
