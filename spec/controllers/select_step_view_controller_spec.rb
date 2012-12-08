describe SelectStepViewController do
  before do
    User.current = User.new
    Account.current = Account.new(:role => 'user')
    
    @health_check = HealthCheck.instantiate(
      :id => 20,
      :permalink => 'test'
    )

    self.controller = SelectStepViewController.alloc.initWithHealthCheck(@health_check, parent:nil)
  end
  
  tests SelectStepViewController
  
  it "should show all possible steps" do
    wait 0.2 do
      controller.tableView.numberOfRowsInSection(0).should == SelectStepViewController::STEPS.size
    end
  end
  
  it "should show step name as cell label" do
    view("Check content").should.not.be.nil
  end
  
  it "should have disclosure indicators" do
    views(UITableViewCell).first.accessoryType.should == UITableViewCellAccessoryDisclosureIndicator
  end
  
  it "should push step view controller on select" do
    controller.navigationController.mock!(:pushViewController)
    tap "Check content"
    1.should == 1
  end
  
  it "should give step view controller an instance of the correct step class on select" do
    controller.navigationController.mock!(:pushViewController)
    ClickLinkStep.mock!(:new, :return => ClickLinkStep.new(:health_check => @health_check))
    tap "Click link"
    1.should == 1
  end
end
