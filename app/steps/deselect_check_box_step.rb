class DeselectCheckBoxStep < Step
  data_attribute :name
  
  def summary
    "Deselect check box"
  end
  
  def detail
    "with name '#{name}'"
  end
end
