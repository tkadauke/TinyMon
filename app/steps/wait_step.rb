class WaitStep < Step
  data_attribute :duration
  
  include Formotion::Formable
  
  form_property :duration, :number
  
  def self.summary
    I18n.t("steps.wait.summary")
  end
  
  def detail
    I18n.t("steps.wait.detail", :duration => self.duration)
  end
end
