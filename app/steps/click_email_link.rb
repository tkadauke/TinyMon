class ClickEmailLinkStep < Step
  data_attribute :link_pattern
  
  member_url "accounts/:account_id/sites/:site_permalink/health_checks/:check_permalink/steps/:id"
  
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
