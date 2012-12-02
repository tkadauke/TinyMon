describe CheckRun do
  extend WebStub::SpecHelpers
  
  it "should extract attributes" do
    check_run = CheckRun.new(:health_check_id => 1, :deployment_id => 1, :log => ['foo', 'bar'], :error_message => 'Test', :status => 'success', :duration => 1.0, :created_at_to_now => 1, :user_id => 1)
    check_run.health_check_id.should == 1
    check_run.deployment_id.should == 1
    check_run.log.should == ['foo', 'bar']
    check_run.error_message.should == 'Test'
    check_run.status.should == 'success'
    check_run.duration.should == 1.0
    check_run.created_at_to_now.should == 1
    check_run.user_id.should == 1
  end
  
  it "should belong to health check" do
    check_run = CheckRun.new(:health_check => { :id => 10, :name => 'Test' })
    check_run.health_check.should.not.be.nil
    check_run.health_check.name.should == 'Test'
  end
  
  it "should have recent scope" do
    stub_request(:get, 'http://mon.tinymon.org/check_runs/recent.json').to_return(json: { check_runs: [{ id: 10 }, { id: 11 }] })
    CheckRun.recent do |result|
      @recent = result
      resume
    end
    
    wait_max 1.0 do
      @recent.size.should == 2
    end
  end
  
  describe "URLs" do
    before do
      @check_run = CheckRun.new(
        :id => 40,
        :health_check => {
          :id => 20,
          :permalink => 'test',
          :site => {
            :id => 10,
            :permalink => 'test-site',
            :account_id => 10
          }
        }
      )
    end
    
    it "should build collection URL" do
      @check_run.collection_url.should == "accounts/10/sites/test-site/health_checks/test/check_runs"
    end
  
    it "should build member URL" do
      @check_run.member_url.should == "accounts/10/sites/test-site/health_checks/test/check_runs/40"
    end
    
    it "should extract permalink from site" do
      @check_run.site_permalink.should == 'test-site'
    end
    
    it "should extract permalink from health check" do
      @check_run.check_permalink.should == 'test'
    end
    
    it "should extract account id from health check" do
      @check_run.account_id.should == 10
    end
  end
end
