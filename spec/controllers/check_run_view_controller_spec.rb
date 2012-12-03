describe CheckRunViewController do
  before do
    @health_check_attributes = {
      :id => 10,
      :name => 'Test',
      :permalink => 'test',
      :site => {
        :id => 10,
        :name => 'Test-Site',
        :permalink => 'test-site',
        :base_url => 'http://test.site',
        :account_id => 10
      }
    }
  end
  
  describe "with successful check run" do
    before do
      @check_run = CheckRun.new(
        :id => 10,
        :status => 'success',
        :duration => 1.0,
        :health_check => @health_check_attributes
      )
      self.controller = CheckRunViewController.alloc.initWithCheckRun(@check_run)
    end
  
    tests CheckRunViewController
  
    it "should have a log view" do
      view('Log').should.not.be.nil
    end
    
    it "should show the health check name" do
      view(@check_run.health_check.name).should.not.be.nil
    end
    
    it "should show the site name" do
      view(@check_run.health_check.site.name).should.not.be.nil
    end
    
    it "should show the timestamp" do
      view("When").should.not.be.nil
    end
    
    it "should show the duration" do
      view("1.0 s").should.not.be.nil
    end
    
    it "should have a success symbol" do
      view("success.png").should.not.be.nil
    end
    
    it "should not have a message view" do
      views(UILabel).find {|l| l.accessibilityLabel == 'Message'}.should.be.nil
    end
  end
  
  describe "with failed check run" do
    before do
      @check_run = CheckRun.new(
        :id => 10,
        :status => 'failure',
        :duration => 1.0,
        :error_message => 'It failed!',
        :health_check => @health_check_attributes
      )
      self.controller = CheckRunViewController.alloc.initWithCheckRun(@check_run)
    end
  
    tests CheckRunViewController
  
    it "should have a message view" do
      view('Message').should.not.be.nil
    end
    
    it "should have a failure symbol" do
      view("failure.png").should.not.be.nil
    end
  end
  
  describe "with loading check run" do
    extend WebStub::SpecHelpers
    extend MotionResource::SpecHelpers
    
    before do
      @check_run = CheckRun.instantiate(
        :id => 10,
        :status => nil,
        :duration => 0.0,
        :health_check => @health_check_attributes
      )
      
      stub_request(:get, "http://mon.tinymon.org/accounts/10/sites/test-site/health_checks/test/check_runs/10.json").to_return(json: { :id => 10, :status => 'success', :duration => 1.0 })
      
      self.controller = CheckRunViewController.alloc.initWithCheckRun(@check_run)
    end
  
    tests CheckRunViewController
  
    it "should not have a message view" do
      views(UILabel).find {|l| l.accessibilityLabel == 'Message'}.should.be.nil
    end
    
    it "should have a spinner" do
      view("In progress").should.not.be.nil
    end
    
    it "should set status image when reloading" do
      views(UIImageView).find {|l| l.accessibilityLabel == 'success.png'}.should.be.nil
      # waiting
      view("success.png").should.not.be.nil
    end
    
    it "should set duration label when reloading" do
      views(UIImageView).find {|l| l.accessibilityLabel == '1.0 s'}.should.be.nil
      # waiting
      view("1.0 s").should.not.be.nil
    end
  end

  describe "with loading failing check run" do
    extend WebStub::SpecHelpers
    extend MotionResource::SpecHelpers
    
    before do
      @check_run = CheckRun.instantiate(
        :id => 10,
        :status => nil,
        :duration => 0.0,
        :health_check => @health_check_attributes
      )
      
      stub_request(:get, "http://mon.tinymon.org/accounts/10/sites/test-site/health_checks/test/check_runs/10.json").to_return(json: { :id => 10, :status => 'failure', :error_message => 'It failed!', :duration => 1.0 })
      
      self.controller = CheckRunViewController.alloc.initWithCheckRun(@check_run)
    end
  
    tests CheckRunViewController
  
    it "should let message view appear" do
      views(UILabel).find {|l| l.accessibilityLabel == 'Message'}.should.be.nil
      # waiting
      view("Message").should.not.be.nil
    end
    
    it "should set status image when reloading" do
      views(UIImageView).find {|l| l.accessibilityLabel == 'success.png'}.should.be.nil
      # waiting
      view("failure.png").should.not.be.nil
    end
  end
end
