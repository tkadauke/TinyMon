describe CheckRunsViewController do
  extend WebStub::SpecHelpers
  extend MotionResource::SpecHelpers
  
  before do
    @health_check = HealthCheck.instantiate(
      :id => 20,
      :permalink => 'test',
      :site => {
        :id => 10,
        :permalink => 'test-site',
        :account_id => 10
      }
    )
    
    stub_request(:get, "http://mon.tinymon.org/accounts/10/sites/test-site/health_checks/test/check_runs.json").to_return(json: { :check_runs => [{ :id => 10, :status => 'success', :created_at_to_now => 1 }, { :id => 15, :status => 'failure', :created_at_to_now => 1 }] })
    
    self.controller = CheckRunsViewController.alloc.initWithHealthCheck(@health_check)
  end
  
  tests CheckRunsViewController
  
  it "should show all check runs" do
    wait 0.2 do
      controller.check_runs.size.should == 2
      controller.tableView.numberOfRowsInSection(0).should == 2
    end
  end
  
  it "should show fuzzy time stamps" do
    view("just now").should.not.be.nil
  end
  
  it "should show status icons" do
    view("failure.png").should.not.be.nil
    view("success.png").should.not.be.nil
  end
  
  it "should filter successful check runs" do
    wait 0.5 do
      sender = Object.new
      def sender.selectedSegmentIndex; 1; end
      controller.change_filter(sender)
    
      view("success.png").should.not.be.nil
      controller.check_runs.size.should == 1
      controller.tableView.numberOfRowsInSection(0).should == 1
    end
  end
  
  it "should filter failed check runs" do
    wait 0.5 do
      sender = Object.new
      def sender.selectedSegmentIndex; 2; end
      controller.change_filter(sender)
    
      view("failure.png").should.not.be.nil
      controller.check_runs.size.should == 1
      controller.tableView.numberOfRowsInSection(0).should == 1
    end
  end

  it "should refresh on pull down" do
    wait 0.5 do
      reset_stubs
      stub_request(:get, "http://mon.tinymon.org/accounts/10/sites/test-site/health_checks/test/check_runs.json").to_return(json: { :check_runs => [{ :id => 10, :status => 'success', :created_at_to_now => 1 }] })
      drag controller.tableView, :to => :bottom, :duration => 1
      
      controller.check_runs.size.should == 1
      controller.tableView.numberOfRowsInSection(0).should == 1
    end
  end
end
