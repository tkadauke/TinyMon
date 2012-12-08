class TestRefreshableViewController < UITableViewController
  include Refreshable
end

describe Refreshable do
  tests TestRefreshableViewController
  
  it "should refresh on pull down" do
    refreshed = false
    controller.on_refresh do
      refreshed = true
    end
    
    wait 0.5 do
      drag controller.tableView, :to => :bottom, :duration => 1
      refreshed.should == true
    end
  end
  
  it "should change title on refresh" do
    wait 0.5 do
      refresh_view = controller.instance_variable_get(:@refresh)
    
      before = refresh_view.attributedTitle
      drag controller.tableView, :to => :bottom, :duration => 1
      refresh_view.attributedTitle.should != before
    end
  end
end
