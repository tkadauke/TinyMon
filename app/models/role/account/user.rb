module Role::Account::User
  include Role::Base
  
  allow :edit_account, :add_user_to_account,
        :create_health_checks, :edit_health_checks, :delete_health_checks, :run_health_checks,
        :create_sites, :edit_sites, :delete_sites, :create_comments,
        :create_health_check_templates, :edit_health_check_template,
        :create_deployments
end
