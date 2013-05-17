class CheckEmailStep < Step
  data_attribute :server, :login, :password
  
  include Formotion::Formable
  
  form_property :server, :string
  form_property :login, :string
  form_property :password, :string, :secure => true
  
  def self.summary
    I18n.t("steps.check_email.summary")
  end
  
  def detail
    I18n.t("steps.check_email.detail", :login => self.login, :server => self.server)
  end
end
