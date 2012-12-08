describe HealthChecksViewController do
  extend WebStub::SpecHelpers
  extend MotionResource::SpecHelpers
  
  before do
    Account.current = Account.instantiate(:id => 5, :role => 'user')
    User.current = User.instantiate(:id => 1, :role => 'user')
    
    site = Site.new(:account_id => 10, :permalink => 'test-site')
    
    stub_request(:get, "http://mon.tinymon.org/accounts/10/sites/test-site/health_checks.json").to_return(json: {
      :health_checks => [
        { :id => 10, :status => 'success', :enabled => true, :name => 'Test', :site => { :id => 10, :name => 'Test-Site' } },
        { :id => 15, :status => 'failure', :enabled => true, :name => 'Foo', :site => { :id => 10, :name => 'Test-Site' } },
        { :id => 20, :status => 'success', :enabled => false, :name => 'Bar', :site => { :id => 10, :name => 'Test-Site' } },
        { :id => 25, :status => 'failure', :enabled => false, :name => 'Baz', :site => { :id => 10, :name => 'Test-Site' } }
      ]
    })
    
    self.controller = HealthChecksViewController.alloc.initWithSite(site)
  end
  
  tests HealthChecksViewController
  
  it "should have a plus button" do
    wait 0.2 do
      controller.navigationItem.rightBarButtonItem.should.not.be.nil
    end
  end
  
  it "should show all health checks" do
    wait 0.5 do
      controller.health_checks.size.should == 4
      controller.tableView.numberOfRowsInSection(0).should == 4
    end
  end
  
  it "should show health check names" do
    view("Test").should.not.be.nil
    view("Foo").should.not.be.nil
  end
  
  it "should show status icons" do
    view("success.png").should.not.be.nil
    view("failure.png").should.not.be.nil
  end
  
  it "should refresh on pull down" do
    wait 0.5 do
      reset_stubs
      stub_request(:get, "http://mon.tinymon.org/accounts/10/sites/test-site/health_checks.json").to_return(json: { :health_checks => [{ :id => 10, :status => 'success', :name => 'Test', :enabled => false, :site => { :id => 10, :name => 'Test-Site' } }] })
      drag controller.tableView, :to => :bottom, :duration => 1
      
      view("offline.png").should.not.be.nil
      controller.health_checks.size.should == 1
      controller.tableView.numberOfRowsInSection(0).should == 1
    end
  end
  
  it "should search health checks" do
    tap controller.search_bar
    controller.search_bar.text = 'Test'
    wait 0.2 do
      controller.filtered_health_checks.size.should == 1
      controller.search_bar.resignFirstResponder
    end
  end
  
  it "should cancel search for health checks" do
    tap controller.search_bar
    controller.searchDisplayController.isActive.should == true
    tap "Cancel"
    controller.searchDisplayController.isActive.should == false
  end
  
  it "should filter for successful health checks" do
    wait 0.5 do
      filter_button(1)
      view('Test').should.not.be.nil
      controller.filtered_health_checks.size.should == 1
    end
  end
  
  it "should filter for failed health checks" do
    wait 0.5 do
      filter_button(2)
      controller.filtered_health_checks.size.should == 1
      view('Foo').should.not.be.nil
    end
  end
  
  it "should filter for enabled health checks" do
    wait 0.5 do
      filter_button(3)
      controller.filtered_health_checks.size.should == 2
      view('Test').should.not.be.nil
      view('Foo').should.not.be.nil
    end
  end
  
  it "should filter for disabled health checks" do
    wait 0.5 do
      filter_button(4)
      controller.filtered_health_checks.size.should == 2
      view('Bar').should.not.be.nil
      view('Baz').should.not.be.nil
    end
  end
  
  it "should filter and then search" do
    wait 0.5 do
      filter_button(3)
      tap controller.search_bar
      controller.search_bar.text = 'Test'
      controller.filtered_health_checks.size.should == 1
      view('Test').should.not.be.nil
      controller.search_bar.resignFirstResponder
    end
  end
  
  it "should search and then filter" do
    tap controller.search_bar
    controller.search_bar.text = 'Test'
    filter_button(3)
    controller.filtered_health_checks.size.should == 1
    view('Test').should.not.be.nil
    controller.search_bar.resignFirstResponder
  end
  
  def filter_button(number)
    controller.instance_variable_get(:@filter).selectedSegmentIndex = number
    controller.change_filter(nil)
  end
end
