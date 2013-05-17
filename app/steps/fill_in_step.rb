class FillInStep < Step
  data_attribute :field, :value
  
  include Formotion::Formable
  
  form_property :field, :string
  form_property :value, :string
  
  def self.summary
    "Fill in"
  end
  
  def detail
    "'#{field}' with '#{value}'"
  end
end
