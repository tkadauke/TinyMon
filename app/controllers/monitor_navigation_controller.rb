class MonitorNavigationController < UINavigationController
  def init
    super
    view_controller = LoginViewController.alloc.init
    pushViewController view_controller, animated:false
  end
end
