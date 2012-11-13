class LoggedInNavigationController < UINavigationController
  def init
    super
    view_controller = SitesViewController.alloc.init
    pushViewController view_controller, animated:false
  end
end
