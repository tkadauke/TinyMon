class ClickEmailLinkStep < Step
  data_attribute :link_pattern
  
  include Formotion::Formable
  
  form_property :link_pattern, :string
  
  def self.summary
    I18n.t("steps.click_email_link.summary")
  end
  
  def detail
    I18n.t("steps.click_email_link.detail", :link_pattern => self.link_pattern)
  end
end
