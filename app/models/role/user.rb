module Role::User
  include Role::Base
  
  def can_edit_profile?(user)
    user == self
  end
  
  def self.delegate_to_account(*permissions)
    permissions.each do |permission|
      define_method "can_#{permission}?" do
        Account.current.send("can_#{permission}?")
      end
    end
  end
  
  delegate_to_account :edit_account, :add_user_to_account,
                      :create_health_checks, :edit_health_checks, :delete_health_checks, :run_health_checks,
                      :create_sites, :edit_sites, :delete_sites,
                      :create_comments,
                      :create_health_check_templates,
                      :create_deployments
  
  def can_remove_user_from_account?(user)
    user != self && can_add_user_to_account?
  end
  
  def can_assign_role_for_user_and_account?(user)
    user != self && can_add_user_to_account?
  end
  
  allow :edit_settings, :see_account_details
  
  allow_if_owner :delete_health_check_template
  
  def method_missing(method, *args)
    if method.to_s =~ /^can_.*\?$/
      false
    else
      super
    end
  end
end
