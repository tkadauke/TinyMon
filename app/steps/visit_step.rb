class VisitStep < Step
  data_attribute :url
  
  include Formotion::Formable
  
  form_property :url, :string
  
  def self.summary
    I18n.t("steps.visit.summary")
  end
  
  def detail
    I18n.t("steps.visit.detail", :url => self.url)
  end
end
