class ClickLinkStep < Step
  data_attribute :name
  
  include Formotion::Formable
  
  form_property :name, :string
  
  def self.summary
    I18n.t("steps.click_link.summary")
  end
  
  def detail
    I18n.t("steps.click_link.detail", :name => self.name)
  end
end
