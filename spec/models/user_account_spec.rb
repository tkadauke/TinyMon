describe UserAccount do
  extend MotionResource::SpecHelpers
  
  it "should extract attributes" do
    user_account = UserAccount.new(:role => 'user', :account_id => 1)
    user_account.role.should == 'user'
    user_account.account_id.should == 1
  end
  
  it "should have one user" do
    user_account = UserAccount.new(:user => { :id => 1, :full_name => 'John Doe' })
    user_account.user.full_name.should == 'John Doe'
  end
  
  describe "URLs" do
    before do
      @user_account = UserAccount.new(
        :id => 10,
        :account_id => 10
      )
    end
    
    it "should build collection URL" do
      @user_account.collection_url.should == "accounts/10/user_accounts"
    end
  
    it "should build member URL" do
      @user_account.member_url.should == "accounts/10/user_accounts/10"
    end
  end
end
