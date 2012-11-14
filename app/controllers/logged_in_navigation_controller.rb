class LoggedInNavigationController < TVNavigationController
  def init
    initWithRootViewController(RecentCheckRunsViewController.alloc.init)
    self.toolbarHidden = false
    self
  end
  
  def initWithRootViewController(view_controller)
    super
    self.toolbarHidden = false
    self
  end
end
