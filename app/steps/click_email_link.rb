class ClickEmailLinkStep < Step
  data_attribute :link_pattern
  
  include Formotion::Formable
  
  form_property :link_pattern, :string
  
  def self.attributes
    superclass.attributes
  end
  
  def summary
    "Click email link"
  end
  
  def detail
    "with pattern '#{link_pattern}'"
  end
end
