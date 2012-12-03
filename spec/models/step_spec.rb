describe Step do
  extend WebStub::SpecHelpers
  extend MotionResource::SpecHelpers
  
  it "should extract attributes" do
    step = Step.new(:type => 'VisitStep', :position => 1, :health_check_id => 1, :data => ['foo', 'bar'])
    step.type.should == 'VisitStep'
    step.position.should == 1
    step.health_check_id.should == 1
    step.data.should == ['foo', 'bar']
  end
  
  it "should belong to health check" do
    step = Step.new(:health_check => { :id => 10, :name => 'Test' })
    step.health_check.should.not.be.nil
    step.health_check.name.should == 'Test'
  end
  
  describe "URLs" do
    before do
      @step = Step.new(
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
      @step.collection_url.should == "accounts/10/sites/test-site/health_checks/test/steps"
    end
  
    it "should build member URL" do
      @step.member_url.should == "accounts/10/sites/test-site/health_checks/test/steps/40"
    end
    
    it "should build sort URL" do
      @step.sort_url.should == "accounts/10/sites/test-site/health_checks/test/steps/sort"
    end
    
    it "should extract permalink from site" do
      @step.site_permalink.should == 'test-site'
    end
    
    it "should extract permalink from health check" do
      @step.check_permalink.should == 'test'
    end
    
    it "should extract account id from health check" do
      @step.account_id.should == 10
    end
  end
  
  it "should sort" do
    stub_request(:post, 'http://mon.tinymon.org/accounts/10/sites/test-site/health_checks/test/steps/sort.json').to_return(body: "")
    check = HealthCheck.new(
      :id => 20,
      :permalink => 'test',
      :site => {
        :id => 10,
        :permalink => 'test-site',
        :account_id => 10
      }
    )
    steps = [Step.new(:id => 40, :health_check => check), Step.new(:id => 50, :health_check => check)]
    Step.sort(steps) do |result|
      @result = result
      resume
    end
    
    wait_max 1.0 do
      @result.should.not.be.nil
    end
  end
  
  it "should create with type as query parameter" do
    stub_request(:post, 'http://mon.tinymon.org/accounts/10/sites/test-site/health_checks/test/steps.json?type=visit').to_return(json: { id: 40, type: "VisitStep" })
    @step = Step.new(
      :type => 'VisitStep',
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
    @step.create do |result|
      @result = result
      resume
    end
    
    wait_max 1.0 do
      @result.should.not.be.nil
      @result.should.is_a VisitStep
    end
  end
  
  it "should have a default summary field" do
    Step.new(:type => 'VisitStep').summary.should == 'VisitStep'
  end
  
  it "should have an empty default detail field" do
    Step.new.detail.should == ""
  end
end
