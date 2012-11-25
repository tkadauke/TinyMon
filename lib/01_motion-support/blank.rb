class Object
  def blank?
    if respond_to?(:empty?)
      empty?
    else
      false
    end
  end
  
  def present?
    !blank?
  end
end

class NilClass
  def blank?
    true
  end
end
