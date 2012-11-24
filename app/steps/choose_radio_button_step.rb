class ChooseRadioButtonStep < Step
  data_attribute :name
  
  def summary
    "Choose radio button"
  end
  
  def detail
    "with name '#{name}'"
  end
end
