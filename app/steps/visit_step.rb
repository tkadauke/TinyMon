class VisitStep < Step
  data_attribute :url
  
  include Formotion::Formable
  
  form_property :url, :string
  
  def self.summary
    "Visit"
  end
  
  def detail
    "page '#{url}'"
  end
end
