class CheckContentStep < Step
  data_attribute :content
  
  def summary
    "Check content"
  end
  
  def detail
    "for '#{content}'"
  end
end
