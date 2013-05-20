class TakeScreenshotStep < Step
  include Formotion::Formable
  
  def self.summary
    I18n.t("steps.take_screenshot.summary")
  end
  
  def detail
  end
end
