class Time
  def self.parse(string)
    date_formatter = NSDateFormatter.alloc.init
    date_formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    date_formatter.dateFromString string
  end
  
  def self.ago_in_words(seconds)
    return "" unless seconds
    
    duration = seconds.abs
    case duration
    when 0..15
      I18n.t("time.ago.just_now")
    when 15..60
      I18n.t("time.ago.seconds")
    when 60..3600
      I18n.t("time.ago.minutes", :duration => (duration / 60).to_i)
    when 3600..86400
      I18n.t("time.ago.hours", :duration => (duration / 3600).to_i)
    else
      I18n.t("time.ago.days", :duration => (duration / 86400).to_i)
    end 
  end
  
  def self.future_in_words(seconds)
    return "" unless seconds

    duration = seconds.abs
    case duration
    when 0..15
      I18n.t("time.future.soon")
    when 15..60
      I18n.t("time.future.seconds")
    when 60..3600
      I18n.t("time.future.minutes", :duration => (duration / 60).to_i)
    when 3600..86400
      I18n.t("time.future.hours", :duration => (duration / 3600).to_i)
    else
      I18n.t("time.future.days", :duration => (duration / 86400).to_i)
    end 
  end
end
