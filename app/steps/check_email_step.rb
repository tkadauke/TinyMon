class CheckEmailStep < Step
  data_attribute :server, :login, :password
  
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
