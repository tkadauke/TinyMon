describe HealthCheck do
  extend WebStub::SpecHelpers
  extend MotionResource::SpecHelpers
  
  it "should extract attributes" do
    health_check = HealthCheck.new(:name => 'Test', :enabled => true, :interval => 60, :description => 'This is a test', :permalink => 'test', :status => 'success', :site_id => 1, :weather => 5, :last_checked_at_to_now => 1, :next_check_at_to_now => 1)
    health_check.name.should == 'Test'
    health_check.enabled.should == true
    health_check.interval.should == 60
    health_check.description.should == 'This is a test'
    health_check.permalink.should == 'test'
    health_check.status.should == 'success'
    health_check.site_id.should == 1
    health_check.weather.should == 5
    health_check.last_checked_at_to_now.should == 1
    health_check.next_check_at_to_now.should == 1
  end
  
  it "should belong to site" do
    health_check = HealthCheck.new(:site => { :id => 10, :name => 'Test site' })
    health_check.site.should.not.be.nil
    health_check.site.name.should == 'Test site'
  end
  
  describe 'has many' do
    before do
      @health_check = HealthCheck.new(:permalink => 'test', :site => { :id => 10, :permalink => 'test-site', :account_id => 10 })
    end
    
    it "should have many check runs" do
      stub_request(:get, 'http://mon.tinymon.org/en/accounts/10/sites/test-site/health_checks/test/check_runs.json').to_return(json: { check_runs: [{ id: 10 }, { id: 11 }] })
      @health_check.check_runs do |results|
        @results = results
        resume
      end
      
      wait_max 1.0 do
        @results.size.should == 2
      end
    end
  
    it "should have many steps" do
      stub_request(:get, 'http://mon.tinymon.org/en/accounts/10/sites/test-site/health_checks/test/steps.json').to_return(json: { steps: [{ id: 10 }, { id: 11 }] })
      @health_check.steps do |results|
        @results = results
        resume
      end
      
      wait_max 1.0 do
        @results.size.should == 2
      end
    end
  end
  
  it "should have all scope" do
    stub_request(:get, 'http://mon.tinymon.org/en/health_checks.json').to_return(json: { health_checks: [{ id: 10 }, { id: 11 }] })
    HealthCheck.all do |result|
      @all = result
      resume
    end
    
    wait_max 1.0 do
      @all.size.should == 2
    end
  end
  
  it "should have upcoming scope" do
    stub_request(:get, 'http://mon.tinymon.org/en/health_checks/upcoming.json').to_return(json: { health_checks: [{ id: 10 }, { id: 11 }] })
    HealthCheck.upcoming do |result|
      @upcoming = result
      resume
    end
    
    wait_max 1.0 do
      @upcoming.size.should == 2
    end
  end
  
  describe "URLs" do
    before do
      @health_check = HealthCheck.new(
        :id => 20,
        :permalink => 'test',
        :site => {
          :id => 10,
          :permalink => 'test-site',
          :account_id => 10
        }
      )
    end
    
    it "should build collection URL" do
      @health_check.collection_url.should == "accounts/10/sites/test-site/health_checks"
    end
  
    it "should build member URL" do
      @health_check.member_url.should == "accounts/10/sites/test-site/health_checks/test"
    end
    
    it "should extract permalink from site" do
      @health_check.site_permalink.should == 'test-site'
    end
    
    it "should extract account id from health check" do
      @health_check.account_id.should == 10
    end
  end
  
  describe "status_icon" do
    it "should be offline icon if not enabled" do
      HealthCheck.new(:enabled => false).status_icon.should == 'offline'
    end
    
    it "should be status icon if enabled" do
      HealthCheck.new(:enabled => true, :status => 'success').status_icon.should == 'success'
      HealthCheck.new(:enabled => true, :status => 'failure').status_icon.should == 'failure'
    end
  end
  
  it "should run" do
    User.current = User.instantiate(:id => 1, :role => 'user')
    health_check = HealthCheck.new(
      :id => 20,
      :permalink => 'test',
      :site => {
        :id => 10,
        :permalink => 'test-site',
        :account_id => 10
      }
    )
    stub_request(:post, 'http://mon.tinymon.org/en/accounts/10/sites/test-site/health_checks/test/check_runs.json').to_return(json: { id: 10 })
    health_check.run do |result|
      @result = result
      resume
    end
    
    wait_max 1.0 do
      @result.should.is_a CheckRun
      @result.id.should == 10
    end
  end
end
