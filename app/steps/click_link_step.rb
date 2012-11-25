class ClickLinkStep < Step
  data_attribute :name
  
  include Formotion::Formable
  
  form_property :name, :string
  
  def summary
    "Click link"
  end
  
  def detail
    "with name '#{name}'"
  end
end
