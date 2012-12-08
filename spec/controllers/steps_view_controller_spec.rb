describe StepsViewController do
  extend WebStub::SpecHelpers
  extend MotionResource::SpecHelpers
  
  before do
    User.current = User.new
    Account.current = Account.new(:role => 'user')
    
    @health_check = HealthCheck.instantiate(
      :id => 20,
      :permalink => 'test',
      :site => {
        :id => 10,
        :permalink => 'test-site',
        :account_id => 10
      }
    )
    
    stub_request(:get, "http://mon.tinymon.org/accounts/10/sites/test-site/health_checks/test/steps.json").to_return(json: {
      :steps => [
        { :id => 10, :type => 'VisitStep', :url => '/' },
        { :id => 11, :type => 'FillInStep', :field => 'username', :value => 'johndoe' },
        { :id => 12, :type => 'FillInStep', :field => 'password', :value => 'password' },
      ]
    })
    
    self.controller = StepsViewController.alloc.initWithHealthCheck(@health_check)
  end
  
  tests StepsViewController
  
  it "should show all steps" do
    wait 0.2 do
      controller.steps.size.should == 3
      controller.tableView.numberOfRowsInSection(0).should == 3
    end
  end
  
  it "should show step summary" do
    view('Visit').should.not.be.nil
  end
  
  it "should show step detail" do
    view("page '/'").should.not.be.nil
  end
  
  it "should have disclosure indicators" do
    views(UITableViewCell).first.accessoryType.should == UITableViewCellAccessoryDisclosureIndicator
  end
  
  it "should disclose step" do
    controller.navigationController.mock!(:pushViewController)
    tap 'Visit'
    1.should == 1
  end
  
  it "should add step" do
    controller.navigationController.mock!(:pushViewController)
    proper_wait 0.5
    controller.add
    1.should == 1
  end
  
  it "should refresh on pull down" do
    wait 0.5 do
      reset_stubs
      stub_request(:get, "http://mon.tinymon.org/accounts/10/sites/test-site/health_checks/test/steps.json").to_return(json: { :steps => [{ :id => 10, :type => 'VisitStep', :url => '/' }] })
      drag controller.tableView, :to => :bottom, :duration => 1
      
      controller.steps.size.should == 1
      controller.tableView.numberOfRowsInSection(0).should == 1
    end
  end
end

describe StepsViewController do
  extend WebStub::SpecHelpers
  extend MotionResource::SpecHelpers
  
  before do
    User.current = User.new
    Account.current = Account.new(:role => 'user')
    
    @health_check = HealthCheck.instantiate(
      :id => 20,
      :permalink => 'test',
      :site => {
        :id => 10,
        :permalink => 'test-site',
        :account_id => 10
      }
    )
    
    stub_request(:get, "http://mon.tinymon.org/accounts/10/sites/test-site/health_checks/test/steps.json").to_return(json: {
      :steps => [
        { :id => 10, :type => 'VisitStep', :url => '/' },
        { :id => 11, :type => 'FillInStep', :field => 'username', :value => 'johndoe' },
        { :id => 12, :type => 'FillInStep', :field => 'password', :value => 'password' },
      ]
    })
    
    self.controller = StepsViewController.alloc.initWithHealthCheck(@health_check)
    self.controller.viewDeckController.mock!(:panningMode=)
    self.controller.edit
  end
  
  tests StepsViewController
  
  it "should show all steps" do
    RunLoopHelpers.wait_till do
      controller.steps.size.should == 3
      controller.tableView.numberOfRowsInSection(0).should == 3
    end
  end
  
  it "should show step summary" do
    view('Visit').should.not.be.nil
  end
  
  it "should show step detail" do
    view("page '/'").should.not.be.nil
  end
  
  it "should refresh on pull down" do
    wait 0.5 do
      reset_stubs
      stub_request(:get, "http://mon.tinymon.org/accounts/10/sites/test-site/health_checks/test/steps.json").to_return(json: { :steps => [{ :id => 10, :type => 'VisitStep', :url => '/' }] })
      drag controller.tableView, :to => :bottom, :duration => 1
      
      controller.steps.size.should == 1
      controller.tableView.numberOfRowsInSection(0).should == 1
    end
  end
  
  it "should reorder cells" do
    stub_request(:post, "http://mon.tinymon.org/accounts/10/sites/test-site/health_checks/test/steps/sort.json").to_return(json: {})
    cells = views(UITableViewCell)
    handle = cells.first.viewByName("Reorder")
    drag handle, :to => :bottom, :duration => 1
    cells_after = views(UITableViewCell)
    cells_after.should == [cells[1], cells[0], cells[2]]
  end
  
  it "should delete step" do
    stub_request(:delete, "http://mon.tinymon.org/accounts/10/sites/test-site/health_checks/test/steps/10.json").to_return(json: {})
    
    cell = views(UITableViewCell).first
    
    number_of_steps_before = controller.steps.size
    tap cell.viewsByClass(UIImageView).first
    proper_wait 0.5
    tap cell.viewByName('Delete')
    tap controller.instance_variable_get(:@action_sheet).viewByName('Yes, delete')
    proper_wait 0.5
    
    controller.steps.size.should == number_of_steps_before - 1
  end

  it "should not delete step if minus button is tapped twice" do
    stub_request(:delete, "http://mon.tinymon.org/accounts/10/sites/test-site/health_checks/test/steps/10.json").to_return(json: {})
    
    cell = views(UITableViewCell).first
    
    number_of_steps_before = controller.steps.size
    tap cell.viewsByClass(UIImageView).first
    tap cell.viewsByClass(UIImageView).first
    proper_wait 0.5
    
    controller.steps.size.should == number_of_steps_before
  end
  
  it "should not delete step if deletion is canceled" do
    stub_request(:delete, "http://mon.tinymon.org/accounts/10/sites/test-site/health_checks/test/steps/10.json").to_return(json: {})
    
    cell = views(UITableViewCell).first
    
    number_of_steps_before = controller.steps.size
    tap cell.viewsByClass(UIImageView).first
    proper_wait 0.5
    tap cell.viewByName('Delete')
    tap controller.instance_variable_get(:@action_sheet).viewByName('No')
    proper_wait 0.5
    
    controller.steps.size.should == number_of_steps_before
  end
end
