module MotionResource
  class Base
    self.root_url = "http://mon.tinymon.org/"
    self.logger = MotionSupport::NetworkLogger.new
  end
end
