module Role::Account::User
  include Role::Base
  
  allow :create_health_checks, :edit_health_checks, :delete_health_checks, :run_health_checks,
        :create_sites, :edit_sites, :delete_sites, :create_comments,
        :create_health_check_templates, :edit_health_check_template,
        :create_health_check_imports, :delete_health_check_imports,
        :create_deployments, :see_deployment_tokens
end
