module Role::Locked
  include Role::Base
  
  def can_see_profile?(user)
    user == self
  end

  def can_see_account?(account)
    !user_account_for(account).nil?
  end

  def method_missing(method, *args)
    if method.to_s =~ /^can_.*\?$/
      false
    else
      super
    end
  end
end
