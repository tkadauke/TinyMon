class CheckCurrentUrlStep < Step
  data_attribute :url
  
  include Formotion::Formable
  
  form_property :url, :string
  
  def self.summary
    I18n.t("steps.check_current_url.summary")
  end
  
  def detail
    I18n.t("steps.check_current_url.detail", :url => self.url)
  end
end
