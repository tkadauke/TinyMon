class LoggedInNavigationController < TVNavigationController
  def init
    initWithRootViewController(RecentCheckRunsViewController.alloc.init)
  end
end
