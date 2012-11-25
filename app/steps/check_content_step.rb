class CheckContentStep < Step
  data_attribute :content
  
  include Formotion::Formable
  
  form_property :content, :string
  
  def self.attributes
    superclass.attributes
  end
  
  def summary
    "Check content"
  end
  
  def detail
    "for '#{content}'"
  end
end
