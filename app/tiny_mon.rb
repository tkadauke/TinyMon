class TinyMon
  cattr_accessor :server
  
  def self.reachable?
    internetStatus = Reachability.reachabilityWithHostName(server).currentReachabilityStatus
    return internetStatus != ::NotReachable
  end
  
  def self.when_reachable(&block)
    if reachable?
      yield
    else
      offline_alert
    end
  end
  
  def self.offline_alert
    UIAlertView.alert("Internet connection", "Can not reach TinyMon server")
  end
end
