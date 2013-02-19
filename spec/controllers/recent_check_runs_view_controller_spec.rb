describe RecentCheckRunsViewController do
  extend WebStub::SpecHelpers
  extend MotionResource::SpecHelpers
  
  before do
    stub_request(:get, "http://mon.tinymon.org/en/check_runs/recent.json").to_return(json: {
      :check_runs => [
        { :id => 10, :status => 'success', :created_at_to_now => 1, :health_check => { :id => 10, :name => 'test', :site => { :id => 10, :name => 'Test site' } } },
        { :id => 15, :status => 'failure', :created_at_to_now => 1, :health_check => { :id => 10, :name => 'test', :site => { :id => 10, :name => 'Test site' } } }
      ]
    })
  end
  
  tests RecentCheckRunsViewController
  
  it "should show all check runs" do
    wait 0.2 do
      controller.check_runs.size.should == 2
      controller.tableView.numberOfRowsInSection(0).should == 2
    end
  end
  
  it "should show site name and fuzzy time stamps" do
    view("Test site, just now").should.not.be.nil
  end
  
  it "should show status icons" do
    view("failure.png").should.not.be.nil
    view("success.png").should.not.be.nil
  end
  
  it "should refresh on pull down" do
    wait 0.5 do
      reset_stubs
      stub_request(:get, "http://mon.tinymon.org/en/check_runs/recent.json").to_return(json: {
        :check_runs => [
          { :id => 10, :status => 'success', :created_at_to_now => 1, :health_check => { :id => 10, :name => 'test', :site => { :id => 10, :name => 'Test site' } } }
        ]
      })
      drag controller.tableView, :to => :bottom, :duration => 1
      
      controller.check_runs.size.should == 1
      controller.tableView.numberOfRowsInSection(0).should == 1
    end
  end
end
