class UpcomingHealthChecksViewController < HealthChecksViewController
  include ActivityTabs
  include RootController
  
  def init
    self.navigationItem.titleView = activity_tabs(1)
    super
  end
  
  def viewDidLoad
    super
    
    # Remove plus button from base class
    self.navigationItem.rightBarButtonItem = nil
    
    load_data
    
    on_refresh do
      load_data
    end
  end
  
  def load_data
    TinyMon.when_reachable do
      HealthCheck.upcoming do |results|
        if results
          self.all_health_checks = results
          change_filter(@filter)
        else
          TinyMon.offline_alert
        end
        done_loading
        end_refreshing
      end
    end
  end
  
  def filter_items
    ["All", "Success", "Failure"]
  end
end
