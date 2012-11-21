class LoggedInViewDeckController < IIViewDeckController
  def init
    super
    self.leftController = LoggedInMenuController.alloc.init
    self.centerController = LoggedInNavigationController.alloc.init
    self.leftLedge = 60
    self.centerhiddenInteractivity = IIViewDeckCenterHiddenNotUserInteractiveWithTapToClose
    self
  end
end