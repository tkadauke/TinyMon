class ClickEmailLinkStep < Step
  data_attribute :link_pattern
  
  def summary
    "Click email link"
  end
  
  def detail
    "with pattern '#{link_pattern}'"
  end
end
