class SubmitFormStep < Step
  data_attribute :name
  
  include Formotion::Formable
  
  form_property :name, :string
  
  def self.summary
    I18n.t("steps.submit_form.summary")
  end
  
  def detail
    I18n.t("steps.submit_form.detail", :name => self.name)
  end
end
