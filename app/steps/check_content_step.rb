class CheckContentStep < Step
  data_attribute :content, :negate
  
  include Formotion::Formable
  
  form_property :content, :string
  form_property :negate, :check
  
  def self.summary
    I18n.t("steps.check_content.summary")
  end
  
  def detail
    if negate
      I18n.t("steps.check_content.negated_detail", :content => self.content)
    else
      I18n.t("steps.check_content.detail", :content => self.content)
    end
  end
end
