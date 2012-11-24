module Role::Admin
  include Role::Base
  
  allow :assign_roles
  
  def method_missing(method, *args)
    if method.to_s =~ /^can_.*\?$/
      true
    else
      super
    end
  end
end
