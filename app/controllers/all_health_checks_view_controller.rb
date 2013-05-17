class AllHealthChecksViewController < HealthChecksViewController
  include RootController
  
  def viewDidLoad
    super
    
    self.title = I18n.t("all_health_checks_controller.title")
    
    self.navigationItem.rightBarButtonItem = nil
    
    on_refresh do
      load_data
    end
  end
  
  def load_data
    TinyMon.when_reachable do
      SVProgressHUD.showWithMaskType(SVProgressHUDMaskTypeClear)
      HealthCheck.all do |results, response|
        SVProgressHUD.dismiss
        if response.ok? && results
          self.health_checks = results
          self.filter_search("", animated:false)
        else
          TinyMon.offline_alert
        end
        tableView.reloadData
        end_refreshing
      end
    end
  end
end
