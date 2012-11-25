class SubmitFormStep < Step
  data_attribute :name
  
  include Formotion::Formable
  
  form_property :name, :string
  
  def summary
    "Submit form"
  end
  
  def detail
    "with name '#{name}'"
  end
end
