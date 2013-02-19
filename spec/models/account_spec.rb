describe Account do
  extend WebStub::SpecHelpers
  extend MotionResource::SpecHelpers
  
  it "should extract attributes" do
    account = Account.new(:name => 'Test', :status => 'success', :role => 'user')
    account.name.should == 'Test'
    account.status.should == 'success'
    account.role.should == 'user'
  end
  
  it "should extend role module" do
    account = Account.new(:name => 'Test', :status => 'success', :role => 'user')
    account.should.is_a Role::Account::User
  end
  
  it "should switch account" do
    stub_request(:post, 'http://mon.tinymon.org/en/accounts/10/switch.json').to_return(json: {})
    @account = Account.instantiate(:id => 10)
    @account.switch do
      resume
    end
    
    wait_max 1.0 do
      Account.current.should == @account
    end
  end
  
  it "should have trivial collection URL" do
    Account.new.collection_url.should == "accounts"
  end
  
  it "should have the ID in the member URL" do
    Account.new(:id => 10).member_url.should == "accounts/10"
  end
end
