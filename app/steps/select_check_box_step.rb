class SelectCheckBoxStep < Step
  data_attribute :name
  
  def summary
    "Select check box"
  end
  
  def detail
    "with name '#{name}'"
  end
end
