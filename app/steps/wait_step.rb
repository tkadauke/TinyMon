class WaitStep < Step
  data_attribute :duration
  
  include Formotion::Formable
  
  form_property :duration, :number
  
  def summary
    "Wait"
  end
  
  def detail
    "for #{duration} seconds"
  end
end
