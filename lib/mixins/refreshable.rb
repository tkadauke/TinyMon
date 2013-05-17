module Refreshable
  def viewDidLoad
    @refresh = UIRefreshControl.alloc.init
    @refresh.attributedTitle = NSAttributedString.alloc.initWithString(I18n.t("refreshable.title"))
    @refresh.addTarget(self, action:'refreshView:', forControlEvents:UIControlEventValueChanged)
    self.refreshControl = @refresh
    super
  end
  
  def refreshView(refresh)
    refresh.attributedTitle = NSAttributedString.alloc.initWithString(I18n.t("refreshable.progress"))
    @on_refresh.call if @on_refresh
  end
  
  def on_refresh(&block)
    @on_refresh = block
  end
  
  def end_refreshing
    return unless @refresh
    
    @refresh.attributedTitle = NSAttributedString.alloc.initWithString(I18n.t("refreshable.last_update", :timestamp => Time.now.strftime("%H:%M:%S")))
    @refresh.endRefreshing
  end
end
