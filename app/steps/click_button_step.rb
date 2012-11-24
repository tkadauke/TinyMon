class ClickButtonStep < Step
  data_attribute :name
  
  def summary
    "Click button"
  end
  
  def detail
    "with name '#{name}'"
  end
end
