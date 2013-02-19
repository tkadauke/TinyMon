describe UserSession do
  extend WebStub::SpecHelpers
  extend MotionResource::SpecHelpers
  
  it "should extract attributes" do
    user_session = UserSession.new(:email => 'john@doe.com', :password => 'password')
    user_session.email.should == 'john@doe.com'
    user_session.password.should == 'password'
  end
  
  it "should have a trivial collection URL" do
    UserSession.new.collection_url.should == "login"
  end
  
  it "should login" do
    stub_request(:post, 'http://mon.tinymon.org/en/login.json').to_return(json: { id: 1 })
    user_session = UserSession.new(:email => 'john@doe.com', :password => 'password')
    user_session.login do |response, json|
      @result = json
      resume
    end
    
    wait_max 1.0 do
      @result.should == { 'id' => 1 }
    end
  end
end
