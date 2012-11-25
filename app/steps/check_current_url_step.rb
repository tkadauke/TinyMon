class CheckCurrentUrlStep < Step
  data_attribute :url
  
  include Formotion::Formable
  
  form_property :url, :string
  
  def self.attributes
    superclass.attributes
  end
  
  def summary
    "Check current URL"
  end
  
  def detail
    "to be '#{url}'"
  end
end
