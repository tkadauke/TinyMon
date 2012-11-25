class ClickButtonStep < Step
  data_attribute :name
  
  include Formotion::Formable
  
  form_property :name, :string
  
  def summary
    "Click button"
  end
  
  def detail
    "with name '#{name}'"
  end
end
