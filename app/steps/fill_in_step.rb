class FillInStep < Step
  data_attribute :field, :value
  
  collection_url "accounts/:account_id/sites/:site_permalink/health_checks/:check_permalink/steps"
  member_url "accounts/:account_id/sites/:site_permalink/health_checks/:check_permalink/steps/:id"
  custom_urls :sort_url => "accounts/:account_id/sites/:site_permalink/health_checks/:check_permalink/steps/sort"
  
  include Formotion::Formable
  
  form_property :field, :string
  form_property :value, :string
  
  def self.attributes
    superclass.attributes
  end
  
  def summary
    "Fill in"
  end
  
  def detail
    "'#{field}' with '#{value}'"
  end
end
