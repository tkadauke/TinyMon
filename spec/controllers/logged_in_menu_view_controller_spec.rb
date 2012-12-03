describe LoggedInMenuViewController do
  extend MotionResource::SpecHelpers

  before do
    Account.current = Account.instantiate(:id => 5, :role => 'user', :name => 'Test account')
    User.current = User.instantiate(:id => 1, :role => 'user', :full_name => 'John Doe')
  end
  
  tests LoggedInMenuViewController
  
  it "should show account name" do
    view('Test account').should.not.be.nil
  end
  
  it "should show user name" do
    view('John Doe').should.not.be.nil
  end
  
  it "should show other menu items" do
    view('Activity').should.not.be.nil
    view('Sites').should.not.be.nil
  end
  
  it "should have multiple sections" do
    controller.tableView.numberOfSections.should == LoggedInMenuViewController::ITEMS.size
  end

  it "should show other section headers" do
    view('Monitoring').should.not.be.nil
    view('Account').should.not.be.nil
  end
  
  it "should have a zero-height first section header" do
    controller.tableView(controller.tableView, heightForHeaderInSection:0).should == 0
  end
end
