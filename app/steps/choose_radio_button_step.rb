class ChooseRadioButtonStep < Step
  data_attribute :name
  
  include Formotion::Formable
  
  form_property :name, :string
  
  def self.summary
    I18n.t("steps.choose_radio_button.summary")
  end
  
  def detail
    I18n.t("steps.choose_radio_button.detail", :name => self.name)
  end
end
