class ClickButtonStep < Step
  data_attribute :name
  
  custom_urls :sort_url => "accounts/:account_id/sites/:site_permalink/health_checks/:check_permalink/steps/sort"
  
  include Formotion::Formable
  
  form_property :name, :string
  
  def self.attributes
    superclass.attributes
  end
  
  def summary
    "Click button"
  end
  
  def detail
    "with name '#{name}'"
  end
end
