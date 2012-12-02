describe CheckRunGraphViewController do
  extend WebStub::SpecHelpers
  
  before do
    @health_check = HealthCheck.instantiate(
      :id => 10,
      :permalink => 'test',
      :site => {
        :id => 10,
        :permalink => 'test-site',
        :account_id => 10
      }
    )
    
    stub_request(:get, "http://mon.tinymon.org/accounts/10/sites/test-site/health_checks/test/check_runs.json").to_return(json: { :check_runs => [{ :id => 10, :duration => 5 }, { :id => 11, :duration => 6 }, { :id => 12, :duration => 4 }] })
    
    self.controller = CheckRunGraphViewController.alloc.initWithHealthCheck(@health_check)
  end
  
  tests CheckRunGraphViewController
  
  it "should have chart view" do
    view("Chart data").should.not.be.nil
  end
end
