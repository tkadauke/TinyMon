class ClickEmailLinkStep < Step
  data_attribute :link_pattern
  
  collection_url "accounts/:account_id/sites/:site_permalink/health_checks/:check_permalink/steps"
  member_url "accounts/:account_id/sites/:site_permalink/health_checks/:check_permalink/steps/:id"
  custom_urls :sort_url => "accounts/:account_id/sites/:site_permalink/health_checks/:check_permalink/steps/sort"
  
  include Formotion::Formable
  
  form_property :link_pattern, :string
  
  def self.attributes
    superclass.attributes
  end
  
  def summary
    "Click email link"
  end
  
  def detail
    "with pattern '#{link_pattern}'"
  end
end
