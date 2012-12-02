def TinyMon.reachable?
  true
end

MotionResource::Base.logger = MotionSupport::NetworkLogger.new
