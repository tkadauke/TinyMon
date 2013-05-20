class CheckCurrentUrlStep < Step
  data_attribute :url, :negate
  
  include Formotion::Formable
  
  form_property :url, :string
  form_property :negate, :check
  
  def self.summary
    I18n.t("steps.check_current_url.summary")
  end
  
  def detail
    if negate
      I18n.t("steps.check_current_url.negated_detail", :url => self.url)
    else
      I18n.t("steps.check_current_url.detail", :url => self.url)
    end
  end
end
