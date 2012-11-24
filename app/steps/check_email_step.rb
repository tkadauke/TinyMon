class CheckEmailStep < Step
  data_attribute :server, :login, :password
  
  member_url "accounts/:account_id/sites/:site_permalink/health_checks/:check_permalink/steps/:id"
  
  include Formotion::Formable
  
  form_property :server, :string
  form_property :login, :string
  form_property :password, :string, :secure => true
  
  def self.attributes
    superclass.attributes
  end
  
  def summary
    "Check E-Mail"
  end
  
  def detail
    "with login '#{login}' on server '#{server}'"
  end
end
