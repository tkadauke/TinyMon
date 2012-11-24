class LoggedInViewDeckController < IIViewDeckController
  def init
    super
    self.leftController = LoggedInMenuViewController.alloc.init
    self.centerController = LoggedInNavigationController.alloc.init
    self.leftLedge = 60
    self.centerhiddenInteractivity = IIViewDeckCenterHiddenNotUserInteractiveWithTapToClose
    self
  end
end