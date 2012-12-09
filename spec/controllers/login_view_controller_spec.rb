describe LoginViewController do
  extend WebStub::SpecHelpers
  extend MotionResource::SpecHelpers
  
  tests LoginViewController
  
  it "should have a email field" do
    view('Email').should.not.be.nil
  end
  
  it "should have a password field" do
    view('Password').should.not.be.nil
  end
  
  it "should have a host name field" do
    view('Host name').should.not.be.nil
  end
  
  it "should have a server field" do
    view('Auto log in').should.not.be.nil
  end
  
  it "should have a login button" do
    view('Login').should.not.be.nil
  end
  
  it "should set root URL when logging in" do
    stub_request(:post, "http://mon.tinymon.org/login.json").to_return(body: "")
    UIAlertView.stub!(:alert, :return => nil) { |title, text| title.should == "Login failed" }
    
    MotionResource::Base.root_url = ""
    controller.submit(controller.form)
    proper_wait 0.2
    MotionResource::Base.root_url.should == "http://mon.tinymon.org/"
  end
  
  it "should set tinymon server when logging in" do
    stub_request(:post, "http://mon.tinymon.org/login.json").to_return(body: "")
    UIAlertView.stub!(:alert, :return => nil) { |title, text| title.should == "Login failed" }
    
    TinyMon.server = ""
    controller.submit(controller.form)
    proper_wait 0.2
    TinyMon.server.should == "mon.tinymon.org"
  end
  
  it "should alert error message if session is invalid" do
    stub_request(:post, "http://mon.tinymon.org/login.json").to_return(body: "")
    
    UIAlertView.mock!(:alert, :return => nil) { |title, text| title.should == 'Login failed' }
    controller.submit(controller.form)
    proper_wait 0.2
  end
  
  it "should set current user when logging in" do
    UIApplication.sharedApplication.delegate.window.stub!(:rootViewController=, :return => nil) { |arg| }
    stub_request(:post, "http://mon.tinymon.org/login.json").to_return(json: { :attempted_record => { :full_name => 'John Doe', :current_account_id => 10 } })
    stub_request(:get, "http://mon.tinymon.org/accounts/10.json").to_return(json: { id: 10, name: 'Test account' })
    
    User.current = nil
    controller.submit(controller.form)
    proper_wait 0.2
    User.current.should.not.be.nil
  end
  
  it "should set current account when logging in" do
    UIApplication.sharedApplication.delegate.window.stub!(:rootViewController=, :return => nil) { |arg| }
    stub_request(:post, "http://mon.tinymon.org/login.json").to_return(json: { :attempted_record => { :full_name => 'John Doe', :current_account_id => 10 } })
    stub_request(:get, "http://mon.tinymon.org/accounts/10.json").to_return(json: { id: 10, name: 'Test account' })
    
    Account.current = nil
    controller.submit(controller.form)
    proper_wait 0.2
    Account.current.should.not.be.nil
  end
end
