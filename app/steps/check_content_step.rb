class CheckContentStep < Step
  data_attribute :content
  
  custom_urls :sort_url => "accounts/:account_id/sites/:site_permalink/health_checks/:check_permalink/steps/sort"
  
  include Formotion::Formable
  
  form_property :content, :string
  
  def self.attributes
    superclass.attributes
  end
  
  def summary
    "Check content"
  end
  
  def detail
    "for '#{content}'"
  end
end
