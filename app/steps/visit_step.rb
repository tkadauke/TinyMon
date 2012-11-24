class VisitStep < Step
  data_attribute :url
  
  collection_url "accounts/:account_id/sites/:site_permalink/health_checks/:check_permalink/steps"
  member_url "accounts/:account_id/sites/:site_permalink/health_checks/:check_permalink/steps/:id"
  custom_urls :sort_url => "accounts/:account_id/sites/:site_permalink/health_checks/:check_permalink/steps/sort"
  
  include Formotion::Formable
  
  form_property :url, :string
  
  def self.attributes
    superclass.attributes
  end
  
  def summary
    "Visit"
  end
  
  def detail
    "page '#{url}'"
  end
end
