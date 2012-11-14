class Time
  def self.parse(string)
    date_formatter = NSDateFormatter.alloc.init
    date_formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    date_formatter.dateFromString string
  end
  
  def ago_in_words
    duration = Time.now - self
    case duration
    when 0..15
      'just now'
    when 15..60
      'less than a minute ago'
    when 60..3600
      "#{(duration / 60).to_i} minutes ago"
    when 3600..86400
      "#{(duration / 3600).to_i} hours ago"
    else
      "#{(duration / 86400).to_i} days ago"
    end 
  end
  
  def future_in_words
    duration = self - Time.now
    case duration
    when 0..15
      'very soon'
    when 15..60
      'in less than a minute'
    when 60..3600
      "in #{(duration / 60).to_i} minutes"
    when 3600..86400
      "in #{(duration / 3600).to_i} hours"
    else
      "in #{(duration / 86400).to_i} days"
    end 
  end
end
