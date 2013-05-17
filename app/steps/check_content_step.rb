class CheckContentStep < Step
  data_attribute :content
  
  include Formotion::Formable
  
  form_property :content, :string
  
  def self.summary
    I18n.t("steps.check_content.summary")
  end
  
  def detail
    I18n.t("steps.check_content.detail", :content => self.content)
  end
end
