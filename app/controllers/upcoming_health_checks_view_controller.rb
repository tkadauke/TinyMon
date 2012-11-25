class UpcomingHealthChecksViewController < HealthChecksViewController
  include ActivityTabs
  include RootController
  
  def init
    self.navigationItem.titleView = activity_tabs(1)
    super
  end
  
  def viewDidLoad
    super
    
    tableView.tableHeaderView = nil
    
    # Remove plus button from base class
    self.navigationItem.rightBarButtonItem = nil
    
    load_data
    
    on_refresh do
      load_data
    end
  end
  
  def load_data
    TinyMon.when_reachable do
      SVProgressHUD.showWithMaskType(SVProgressHUDMaskTypeClear)
      HealthCheck.upcoming do |results|
        SVProgressHUD.dismiss
        if results
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
  
  def filter_items
    ["All", "Success", "Failure"]
  end
end
