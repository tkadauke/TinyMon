describe User do
  it "should extract attributes" do
    user = User.new(:role => 'user', :full_name => 'John Doe', :current_account_id => 1, :email => 'john@doe.com')
    user.role.should == 'user'
    user.full_name.should == 'John Doe'
    user.current_account_id.should == 1
    user.email.should == 'john@doe.com'
  end
  
  it "should extend role module" do
    user = User.new(:role => 'user')
    user.should.is_a Role::User
  end
  
  it "should have many accounts" do
    user = User.new(:accounts => [{ :id => 10 }, { :id => 20 }])
    user.accounts.size.should == 2
    user.accounts.first.should.is_a Account
  end
  
  it "should have the ID in the member URL" do
    User.new(:id => 10).member_url.should == "users/10"
  end
  
  describe "gravatar_url" do
    it "should build the gravatar URL from the email address" do
      User.new(:email => 'john@doe.com').gravatar_url.should =~ /6a6c19fea4a3676970167ce51f39e6ee/
    end
    
    it "should make no difference in case for the gravatar URL" do
      User.new(:email => 'john@doe.com').gravatar_url.should == User.new(:email => 'JOHN@DOE.COM').gravatar_url
    end
    
    it "should ignore leading and trailing spaces for the gravatar URL" do
      User.new(:email => 'john@doe.com').gravatar_url.should == User.new(:email => '  john@doe.com ').gravatar_url
    end
  end
end
