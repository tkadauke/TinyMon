module Role::Account::Observer
  include Role::Base
  
  def method_missing(method)
    if method.to_s =~ /^can_.*\?$/
      false
    else
      super
    end
  end
end