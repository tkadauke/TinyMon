class WaitStep < Step
  data_attribute :duration
  
  custom_urls :sort_url => "accounts/:account_id/sites/:site_permalink/health_checks/:check_permalink/steps/sort"
  
  include Formotion::Formable
  
  form_property :duration, :number
  
  def self.attributes
    superclass.attributes
  end
  
  def summary
    "Wait"
  end
  
  def detail
    "for #{duration} seconds"
  end
end
