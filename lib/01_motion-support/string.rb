class String
  def pluralize
    if self[-1] == 's'
      self
    else
      self + "s"
    end
  end

  def singularize
    if self[-1] == 's'
      self[0..-2]
    else
      self
    end
  end
  
  def classify
    singularize.camelize
  end
end
