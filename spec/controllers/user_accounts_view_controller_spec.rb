describe UserAccountsViewController do
  extend WebStub::SpecHelpers
  extend MotionResource::SpecHelpers
  
  before do
    Account.current = Account.instantiate(:id => 5, :role => 'user')
    
    stub_request(:get, "http://mon.tinymon.org/en/accounts/5/user_accounts.json").to_return(json: {
      :user_accounts => [
        { :id => 10, :user => { :id => 10, :full_name => 'John Doe', :email => 'johndoe@example.com' } },
        { :id => 11, :user => { :id => 11, :full_name => 'Jane Doe', :email => 'janedoe@example.com' } }
      ]
    })
  end
  
  tests UserAccountsViewController
  
  it "should show all users" do
    wait 0.5 do
      controller.user_accounts.size.should == 2
      controller.tableView.numberOfRowsInSection(0).should == 2
    end
  end
  
  it "should show user names" do
    view("John Doe").should.not.be.nil
    view("Jane Doe").should.not.be.nil
  end
  
  it "should have disclosure indicators" do
    views(UITableViewCell).first.accessoryType.should == UITableViewCellAccessoryDisclosureIndicator
  end
  
  it "should refresh on pull down" do
    wait 0.5 do
      reset_stubs
      stub_request(:get, "http://mon.tinymon.org/en/accounts/5/user_accounts.json").to_return(json: { :user_accounts => [{ :id => 10, :user => { :id => 10, :full_name => 'John Doe', :email => 'johndoe@example.com' } }] })
      drag controller.tableView, :to => :bottom, :duration => 1
      
      view("John Doe").should.not.be.nil
      controller.user_accounts.size.should == 1
      controller.tableView.numberOfRowsInSection(0).should == 1
    end
  end
  
  it "should disclose user" do
    stub_request(:get, "http://mon.tinymon.org/en/users/10.json").to_return(json: { :id => 10, :full_name => 'John Doe' })
    controller.navigationController.mock!(:pushViewController)
    tap view("John Doe")
    1.should == 1
  end
end
