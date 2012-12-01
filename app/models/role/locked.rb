module Role::Locked
  include Role::Base
  
  def can_see_profile?(user)
    user == self
  end

  def method_missing(method, *args)
    if method.to_s =~ /^can_.*\?$/
      false
    else
      super
    end
  end
end
