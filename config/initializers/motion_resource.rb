module MotionResource
  class Base
    self.root_url = "http://mon.tinymon.org/en/"
    self.logger = MotionSupport::NetworkLogger.new
  end
end
