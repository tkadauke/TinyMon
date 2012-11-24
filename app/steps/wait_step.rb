class WaitStep < Step
  data_attribute :duration
  
  def summary
    "Wait"
  end
  
  def detail
    "for #{duration} seconds"
  end
end
