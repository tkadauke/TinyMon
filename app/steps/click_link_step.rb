class ClickLinkStep < Step
  data_attribute :name
  
  def summary
    "Click link"
  end
  
  def detail
    "with name '#{name}'"
  end
end
