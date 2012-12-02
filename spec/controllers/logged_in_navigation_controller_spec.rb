describe LoggedInNavigationController do
  before do
    @view_controller = UIViewController.alloc.init
    self.controller = LoggedInNavigationController.alloc.initWithRootViewController(@view_controller)
  end
  
  tests LoggedInNavigationController
  
  it "should show root view controller" do
    view(@view_controller.view).should.not.be.nil
  end
  
  it "should show toolbar" do
    controller.isToolbarHidden.should == false
  end
end

describe LoggedInNavigationController do
  extend WebStub::SpecHelpers
  
  before do
    stub_request(:get, "http://mon.tinymon.org/check_runs/recent.json").to_return(json: { :check_runs => [{ :id => 10, :status => 'success', :health_check => { :id => 10, :site => { :id => 10, :name => 'Test site' } } }] })
    
    self.controller = LoggedInNavigationController.alloc.init
  end
  
  tests LoggedInNavigationController
  
  it "should show recent check runs by default" do
    view('success.png').should.not.be.nil
  end
  
  it "should show toolbar" do
    controller.isToolbarHidden.should == false
  end
end