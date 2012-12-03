describe Site do
  extend WebStub::SpecHelpers
  extend MotionResource::SpecHelpers
  
  it "should extract attributes" do
    site = Site.new(:url => 'http://test.url', :name => 'Test site', :account_id => 10, :permalink => 'test-site', :status => 'success')
    site.url.should == 'http://test.url'
    site.name.should == 'Test site'
    site.account_id.should == 10
    site.permalink.should == 'test-site'
    site.status.should == 'success'
  end
  
  describe 'has many' do
    before do
      @site = Site.new(:permalink => 'test-site', :account_id => 10)
    end
    
    it "should have many health checks" do
      stub_request(:get, 'http://mon.tinymon.org/accounts/10/sites/test-site/health_checks.json').to_return(json: { health_checks: [{ id: 10 }, { id: 11 }] })
      @site.health_checks do |results|
        @results = results
        resume
      end
      
      wait_max 1.0 do
        @results.size.should == 2
      end
    end
  end
  
  describe "URLs" do
    before do
      @site = Site.new(
        :permalink => 'test-site',
        :account_id => 10
      )
    end
    
    it "should have trivial collection URL" do
      @site.collection_url.should == "sites"
    end
  
    it "should build member URL" do
      @site.member_url.should == "accounts/10/sites/test-site"
    end
  end
end
