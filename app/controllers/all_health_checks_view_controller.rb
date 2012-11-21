class AllHealthChecksViewController < HealthChecksViewController
  include RootController
  
  def viewDidLoad
    super
    
    self.title = "All Health Checks"
    
    self.navigationItem.rightBarButtonItem = nil
    
    on_refresh do
      load_data
    end
  end
  
  def load_data
    TinyMon.when_reachable do
      SVProgressHUD.showWithMaskType(SVProgressHUDMaskTypeClear)
      HealthCheck.all do |results|
        SVProgressHUD.dismiss
        if results
          self.all_health_checks = results
          self.change_filter(@filter)
        else
          TinyMon.offline_alert
        end
        tableView.reloadData
        end_refreshing
      end
    end
  end
end
