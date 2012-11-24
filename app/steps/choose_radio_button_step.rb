class ChooseRadioButtonStep < Step
  data_attribute :name
  
  member_url "accounts/:account_id/sites/:site_permalink/health_checks/:check_permalink/steps/:id"
  
  include Formotion::Formable
  
  form_property :name, :string
  
  def self.attributes
    superclass.attributes
  end
  
  def summary
    "Choose radio button"
  end
  
  def detail
    "with name '#{name}'"
  end
end
