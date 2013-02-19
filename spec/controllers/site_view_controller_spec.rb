module SiteViewControllerHelper
  def edit_name(value)
    name = view('Name')
    tap name
    field = name.up(UITableViewCell).viewsByClass(UITextField).first
    field.text = value
    field.resignFirstResponder
  end
  
  def edit_base_url(value)
    url = view('Base URL')
    tap url
    field = url.up(UITableViewCell).viewsByClass(UITextField).first
    field.text = value
    field.resignFirstResponder
  end
end

describe SiteViewController do
  extend WebStub::SpecHelpers
  extend MotionResource::SpecHelpers
  
  before do
    Account.current = Account.instantiate(:id => 5, :role => 'user')
    User.current = User.instantiate(:id => 1, :role => 'user')
    
    @site = Site.instantiate(
      :id => 10,
      :name => 'Test site',
      :url => 'http://test.site',
      :permalink => 'test-site',
      :status => 'success',
      :account_id => 10
    )
    
    self.controller = SiteViewController.alloc.initWithSite(@site, parent:nil)
  end
  
  tests SiteViewController
  
  it "should show site name" do
    view('Test site').should.not.be.nil
  end
  
  it "should show base URL" do
    view('http://test.site').should.not.be.nil
  end
  
  it "should show status" do
    view('success.png').should.not.be.nil
  end
  
  it "should show health checks" do
    view('Health Checks').should.not.be.nil
  end
  
  it "should open the site on tap" do
    UIApplication.sharedApplication.mock!(:openURL)
    tap 'Base URL'
    1.should == 1
  end
  
  it "should disclose health checks" do
    controller.navigationController.mock!(:pushViewController)
    tap "Health Checks"
    1.should == 1
  end
end

describe SiteViewController do
  extend WebStub::SpecHelpers
  extend MotionResource::SpecHelpers
  extend SiteViewControllerHelper
  
  before do
    Account.current = Account.instantiate(:id => 5, :role => 'user')
    User.current = User.instantiate(:id => 1, :role => 'user')
    
    @site = Site.instantiate(
      :id => 10,
      :name => 'Test site',
      :url => 'http://test.site',
      :permalink => 'test-site',
      :status => 'success',
      :account_id => 10
    )
    
    self.controller = SiteViewController.alloc.initWithSite(@site, parent:nil)
    controller.edit
  end
  
  tests SiteViewController
  
  it "should show name" do
    view('Name').should.not.be.nil
  end
  
  it "should show base URL" do
    view('Base URL').should.not.be.nil
  end
  
  it "should edit name" do
    edit_name('Super site')
    controller.form.render[:name].should == 'Super site'
  end
  
  it "should edit base URL" do
    edit_base_url('http://test.site/foo')
    controller.form.render[:url].should == 'http://test.site/foo'
  end
  
  it "should save changes" do
    stub_request(:put, 'http://mon.tinymon.org/en/accounts/10/sites/test-site.json').to_return(json: {})
    
    edit_name('Super site')
    edit_base_url('http://test.site/foo')
    
    tap view('Save')
    view('Status').should.not.be.nil
  end
  
  it "should delete health check" do
    controller.navigationController.mock!(:popViewControllerAnimated)
    stub_request(:delete, 'http://mon.tinymon.org/en/accounts/10/sites/test-site.json').to_return(json: { id: 30 })
    tap view('Delete')
    tap controller.instance_variable_get(:@action_sheet).viewByName('Yes, delete')
    controller.instance_variable_get(:@deleted).should == true
  end
  
  it "should not delete health check when canceled" do
    tap view('Delete')
    tap controller.instance_variable_get(:@action_sheet).viewByName('No')
    controller.instance_variable_get(:@deleted).should.be.nil
  end
end

describe SiteViewController do
  extend WebStub::SpecHelpers
  extend MotionResource::SpecHelpers
  extend SiteViewControllerHelper
  
  before do
    Account.current = Account.instantiate(:id => 5, :role => 'user')
    User.current = User.instantiate(:id => 1, :role => 'user')
    
    self.controller = SiteViewController.alloc.initWithParent(nil)
  end
  
  tests SiteViewController

  it "should show name" do
    view('Name').should.not.be.nil
  end
  
  it "should show base URL" do
    view('Base URL').should.not.be.nil
  end
  
  it "should create site" do
    controller.navigationController.mock!(:popViewControllerAnimated)
    stub_request(:post, 'http://mon.tinymon.org/en/sites.json').to_return(json: {
      :id => 30,
      :name => 'Test site',
      :url => 'http://test.site'
    })
    
    edit_name('Test site')
    edit_base_url('http://test.site')
    
    tap view('Save')
    controller.instance_variable_get(:@created).should == true
  end
end
