module ActivityTabs
  def activity_tabs(selected)
    ctrl = UISegmentedControl.alloc.initWithFrame(CGRectZero)
    ctrl.segmentedControlStyle = UISegmentedControlStyleBar
    ctrl.insertSegmentWithTitle("Recent", atIndex:0, animated:false)
    ctrl.insertSegmentWithTitle("Upcoming", atIndex:1, animated:false)
    ctrl.selectedSegmentIndex = selected
    ctrl.sizeToFit
    ctrl.addTarget(self, action:'switch_activity_tab:', forControlEvents:UIControlEventValueChanged)
    ctrl
  end
  
  def switch_activity_tab(sender)
    view_controller = case sender.selectedSegmentIndex
    when 0
      RecentCheckRunsViewController.alloc.init
    when 1
      UpcomingHealthChecksViewController.alloc.init
    end
    
    self.navigationController.rootViewController = view_controller
  end
end
