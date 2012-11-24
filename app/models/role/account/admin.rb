module Role::Account::Admin
  include Role::Base
  
  def method_missing(method)
    if method.to_s =~ /^can_.*\?$/
      true
    else
      super
    end
  end
end