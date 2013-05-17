class ClickButtonStep < Step
  data_attribute :name
  
  include Formotion::Formable
  
  form_property :name, :string
  
  def self.summary
    I18n.t("steps.click_button.summary")
  end
  
  def detail
    I18n.t("steps.click_button.detail", :name => self.name)
  end
end
