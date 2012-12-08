describe MonitorNavigationController do
  tests MonitorNavigationController
  
  it "should show login view controller" do
    view('Login').should.not.be.nil
  end
end