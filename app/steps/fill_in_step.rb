class FillInStep < Step
  data_attribute :field, :value
  
  include Formotion::Formable
  
  form_property :field, :string
  form_property :value, :string
  
  def self.summary
    I18n.t("steps.fill_in.summary")
  end
  
  def detail
    I18n.t("steps.fill_in.detail", :field => self.field, :value => self.value)
  end
end
