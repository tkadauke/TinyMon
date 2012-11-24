class FillInStep < Step
  data_attribute :field, :value
  
  def summary
    "Fill in"
  end
  
  def detail
    "'#{field}' with '#{value}'"
  end
end
