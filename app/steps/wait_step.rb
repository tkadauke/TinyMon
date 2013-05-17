class WaitStep < Step
  data_attribute :duration
  
  include Formotion::Formable
  
  form_property :duration, :number
  
  def self.summary
    "Wait"
  end
  
  def detail
    "for #{duration} seconds"
  end
end
