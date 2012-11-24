class SubmitFormStep < Step
  data_attribute :name
  
  def summary
    "Submit form"
  end
  
  def detail
    "with name '#{name}'"
  end
end
