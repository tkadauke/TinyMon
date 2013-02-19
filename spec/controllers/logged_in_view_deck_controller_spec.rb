describe LoggedInViewDeckController do
  extend WebStub::SpecHelpers
  extend MotionResource::SpecHelpers
  
  before do
    Account.current = Account.instantiate(:id => 5, :role => 'user', :name => 'Test account')
    User.current = User.instantiate(:id => 1, :role => 'user', :full_name => 'John Doe')
    
    stub_request(:get, "http://mon.tinymon.org/en/check_runs/recent.json").to_return(json: { :check_runs => [{ :id => 10, :status => 'success', :health_check => { :id => 10, :site => { :id => 10, :name => 'Test site' } } }] })
    
    self.controller = LoggedInViewDeckController.alloc.init
  end
  
  tests LoggedInViewDeckController
  
  it "should show recent check runs by default" do
    view('success.png').should.not.be.nil
  end
  
  it "should reveal menu on swipe" do
    table = view('success.png').up(UITableView)
    flick table, :to => :right
    table.superview.convertPoint(table.frame.origin, toView:nil).x.should > 150
  end
end
