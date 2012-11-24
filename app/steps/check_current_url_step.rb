class CheckCurrentUrlStep < Step
  data_attribute :url
  
  def summary
    "Check current URL"
  end
  
  def detail
    "to be '#{url}'"
  end
end
