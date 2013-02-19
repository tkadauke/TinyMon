describe SitesViewController do
  extend WebStub::SpecHelpers
  extend MotionResource::SpecHelpers
  
  before do
    Account.current = Account.instantiate(:id => 5, :role => 'user')
    User.current = User.instantiate(:id => 1, :role => 'user')
    
    stub_request(:get, "http://mon.tinymon.org/en/sites.json").to_return(json: {
      :sites => [
        { :id => 10, :name => 'Test-Site', :status => 'success' },
        { :id => 11, :name => 'Foo-Site', :status => 'failure' },
        { :id => 12, :name => 'Bar-Site', :status => 'success' },
        { :id => 13, :name => 'Baz-Site', :status => 'failure' }
      ]
    })
  end
  
  tests SitesViewController
  
  it "should have a plus button" do
    wait 0.2 do
      controller.navigationItem.rightBarButtonItem.should.not.be.nil
    end
  end
  
  it "should show all sites" do
    wait 0.5 do
      controller.sites.size.should == 4
      controller.tableView.numberOfRowsInSection(0).should == 4
    end
  end
  
  it "should show sites names" do
    view("Test-Site").should.not.be.nil
    view("Foo-Site").should.not.be.nil
  end
  
  it "should show status icons" do
    view("success.png").should.not.be.nil
    view("failure.png").should.not.be.nil
  end
  
  it "should refresh on pull down" do
    wait 0.5 do
      reset_stubs
      stub_request(:get, "http://mon.tinymon.org/en/sites.json").to_return(json: { :sites => [{ :id => 10, :name => 'Test-Site', :status => 'success' }] })
      drag controller.tableView, :to => :bottom, :duration => 1
      
      view("success.png").should.not.be.nil
      controller.sites.size.should == 1
      controller.tableView.numberOfRowsInSection(0).should == 1
    end
  end
  
  it "should search sites" do
    tap controller.search_bar
    controller.search_bar.text = 'Test'
    wait 0.2 do
      controller.filtered_sites.size.should == 1
      controller.search_bar.resignFirstResponder
    end
  end
  
  it "should cancel search for sites" do
    tap controller.search_bar
    controller.searchDisplayController.isActive.should == true
    tap "Cancel"
    controller.searchDisplayController.isActive.should == false
  end
  
  it "should filter for successful sites" do
    wait 0.5 do
      filter_button(1)
      view('Test-Site').should.not.be.nil
      controller.filtered_sites.size.should == 2
    end
  end
  
  it "should filter for failed health checks" do
    wait 0.5 do
      filter_button(2)
      controller.filtered_sites.size.should == 2
      view('Foo-Site').should.not.be.nil
    end
  end
  
  it "should filter and then search" do
    wait 0.5 do
      filter_button(1)
      tap controller.search_bar
      controller.search_bar.text = 'Test'
      controller.filtered_sites.size.should == 1
      view('Test-Site').should.not.be.nil
      controller.search_bar.resignFirstResponder
    end
  end
  
  it "should search and then filter" do
    tap controller.search_bar
    controller.search_bar.text = 'Test'
    filter_button(1)
    controller.filtered_sites.size.should == 1
    view('Test-Site').should.not.be.nil
    controller.search_bar.resignFirstResponder
  end
  
  def filter_button(number)
    controller.instance_variable_get(:@filter).selectedSegmentIndex = number
    controller.change_filter(nil)
  end
end
