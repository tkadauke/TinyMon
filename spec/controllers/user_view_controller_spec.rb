describe UserViewController do
  extend WebStub::SpecHelpers
  extend MotionResource::SpecHelpers
  
  before do
    Account.current = Account.instantiate(:id => 5, :role => 'user')
    User.current = User.instantiate(:id => 1, :role => 'user')
    
    @user = User.instantiate(
      :id => 10,
      :full_name => 'John Doe',
      :email => 'johndoe@example.com'
    )
    
    stub_request(:get, "http://mon.tinymon.org/users/10.json").to_return(json: { :id => 10, :accounts => [{ :id => 10, :name => 'Test' }, { :id => 11, :name => 'Foo' }] })
    
    self.controller = UserViewController.alloc.initWithUser(@user)
  end
  
  tests SiteViewController
  
  it "should show site name" do
    view('Name').should.not.be.nil
    view('John Doe').should.not.be.nil
  end
  
  it "should show email" do
    view('Email').should.not.be.nil
    view('johndoe@example.com').should.not.be.nil
  end
  
  it "should show account names" do
    view('Test').should.not.be.nil
    view('Foo').should.not.be.nil
  end
end
