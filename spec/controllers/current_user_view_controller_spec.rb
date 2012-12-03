describe CurrentUserViewController do
  extend WebStub::SpecHelpers
  extend MotionResource::SpecHelpers
  
  before do
    User.current = User.instantiate(:id => 1, :role => 'user')
    
    stub_request(:get, "http://mon.tinymon.org/users/1.json").to_return(json: { :id => 1, :role => 'user', :full_name => 'John Doe', :email => 'john@doe.com', :accounts => [] })
    
    self.controller = CurrentUserViewController.alloc.init
  end
  
  tests CurrentUserViewController
  
  it "should show current user's full name" do
    view("John Doe").should.not.be.nil
  end
  
  it "should show current user's email" do
    view("john@doe.com").should.not.be.nil
  end
end
