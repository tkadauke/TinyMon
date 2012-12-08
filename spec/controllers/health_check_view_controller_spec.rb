module HealthCheckViewControllerHelper
  def edit_name(value)
    name = view('Name')
    tap name
    field = name.up(UITableViewCell).viewsByClass(UITextField).first
    field.text = value
    field.resignFirstResponder
  end
  
  def edit_description(value)
    desc = view('Description')
    tap desc
    field = desc.up(UITableViewCell).viewsByClass(UITextView).first
    field.text = value
    field.delegate.textViewDidChange(field)
    field.resignFirstResponder
  end
  
  def edit_interval(value)
    interval = view('Check Interval')
    tap interval
    row = controller.form.sections.first.rows[2]
    picker = row.object.picker
    picker.selectRow(value, inComponent: 0, animated: true)
    row.object.pickerView(picker, didSelectRow:value, inComponent:0)
    row.text_field.resignFirstResponder
  end
  
  def switch_active
    active = view('Active')
    tap active
    switch = active.up(UITableViewCell).viewsByClass(UISwitch).first
    tap switch
  end
end

describe HealthCheckViewController do
  extend WebStub::SpecHelpers
  extend MotionResource::SpecHelpers
  
  before do
    Account.current = Account.instantiate(:id => 5, :role => 'user')
    User.current = User.instantiate(:id => 1, :role => 'user')
    
    @health_check = HealthCheck.instantiate(
      :id => 30,
      :name => 'Test',
      :description => 'This is a test',
      :enabled => true,
      :interval => 60,
      :permalink => 'test',
      :last_checked_at_to_now => 1,
      :next_check_at_to_now => 1,
      :status => 'success',
      :weather => 5,
      :site => {
        :id => 10,
        :name => 'Test site',
        :permalink => 'test-site',
        :account_id => 10
      }
    )
    
    self.controller = HealthCheckViewController.alloc.initWithHealthCheck(@health_check, parent:nil)
  end
  
  tests HealthCheckViewController
  
  it "should show health check name" do
    view('Test').should.not.be.nil
  end
  
  it "should show site name" do
    view('Test site').should.not.be.nil
  end
  
  it "should show description" do
    view('This is a test').should.not.be.nil
  end
  
  it "should show check interval" do
    view('60').should.not.be.nil
  end
  
  it "should show enabled status" do
    view('Yes').should.not.be.nil
  end
  
  it "should show last check timestamp" do
    view('just now').should.not.be.nil
  end
  
  it "should show next check timestamp" do
    view('very soon').should.not.be.nil
  end
  
  it "should show status" do
    view('success.png').should.not.be.nil
  end
  
  it "should show weather icon" do
    view('weather-5.png').should.not.be.nil
  end
  
  it "should disclose description" do
    controller.navigationController.mock!(:pushViewController)
    tap view('Description')
    1.should == 1
  end
  
  it "should run health check" do
    stub_request(:post, "http://mon.tinymon.org/accounts/10/sites/test-site/health_checks/test/check_runs.json").to_return(json: {
      :id => 10,
      :status => 'success',
      :created_at_to_now => 1,
      :health_check => {
        :id => 10,
        :name => 'Test',
        :permalink => 'test',
        :site => {
          :id => 10,
          :name => 'Test-Site',
          :permalink => 'test-site',
          :account_id => 10
        }
      }
    })
    controller.navigationController.mock!(:pushViewController)
    tap view('Run now')
    1.should == 1
  end
  
  it "should disclose last check run" do
    stub_request(:get, "http://mon.tinymon.org/accounts/10/sites/test-site/health_checks/test/check_runs.json").to_return(json: { :check_runs => [{ :id => 10, :status => 'success', :created_at_to_now => 1 }, { :id => 15, :status => 'failure', :created_at_to_now => 1 }] })
    controller.navigationController.mock!(:pushViewController)
    tap view('Last Check')
    1.should == 1
  end
end

describe HealthCheckViewController do
  extend WebStub::SpecHelpers
  extend MotionResource::SpecHelpers
  extend HealthCheckViewControllerHelper
  
  before do
    Account.current = Account.instantiate(:id => 5, :role => 'user')
    User.current = User.instantiate(:id => 1, :role => 'user')
    
    @health_check = HealthCheck.instantiate(
      :id => 30,
      :name => 'Test',
      :description => 'This is a test',
      :enabled => true,
      :interval => 60,
      :permalink => 'test',
      :last_checked_at_to_now => 1,
      :next_check_at_to_now => 1,
      :status => 'success',
      :weather => 5,
      :site => {
        :id => 10,
        :name => 'Test site',
        :permalink => 'test-site',
        :account_id => 10
      }
    )
    
    self.controller = HealthCheckViewController.alloc.initWithHealthCheck(@health_check, parent:nil)
    controller.edit
  end
  
  tests HealthCheckViewController
  
  it "should show name" do
    view('Name').should.not.be.nil
  end
  
  it "should show description" do
    view('Description').should.not.be.nil
  end
  
  it "should show interval" do
    view('Check Interval').should.not.be.nil
  end
  
  it "should show active" do
    view('Active').should.not.be.nil
  end
  
  it "should edit name" do
    edit_name('Hello')
    controller.form.render[:name].should == 'Hello'
  end
  
  it "should edit description" do
    edit_description('What is this')
    controller.form.render[:description].should == 'What is this'
  end
  
  it "should edit interval" do
    edit_interval(0)
    controller.form.render[:interval].should == '1'
  end
  
  it "should edit active" do
    switch_active
    controller.form.render[:enabled].should == false
  end
  
  it "should save changes" do
    stub_request(:put, 'http://mon.tinymon.org/accounts/10/sites/test-site/health_checks/test.json').to_return(json: {})
    
    edit_name('Hello')
    edit_description('How are things')
    edit_interval(3)
    switch_active
    
    tap view('Save')
    view('just now').should.not.be.nil
  end
  
  it "should delete health check" do
    stub_request(:delete, 'http://mon.tinymon.org/accounts/10/sites/test-site/health_checks/test.json').to_return(json: { id: 30 })
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

describe HealthCheckViewController do
  extend WebStub::SpecHelpers
  extend MotionResource::SpecHelpers
  extend HealthCheckViewControllerHelper
  
  before do
    Account.current = Account.instantiate(:id => 5, :role => 'user')
    User.current = User.instantiate(:id => 1, :role => 'user')
    
    @site = Site.instantiate(
      :id => 10,
      :name => 'Test site',
      :permalink => 'test-site',
      :account_id => 10
    )
    
    self.controller = HealthCheckViewController.alloc.initWithSite(@site, parent:nil)
  end
  
  tests HealthCheckViewController
  
  it "should show name" do
    view('Name').should.not.be.nil
  end
  
  it "should show description" do
    view('Description').should.not.be.nil
  end
  
  it "should show interval" do
    view('Check Interval').should.not.be.nil
  end
  
  it "should show active" do
    view('Active').should.not.be.nil
  end
  
  it "should create health check" do
    stub_request(:post, 'http://mon.tinymon.org/accounts/10/sites/test-site/health_checks.json').to_return(json: {
      :id => 30,
      :name => 'Test',
      :description => 'This is a test',
      :enabled => true,
      :interval => 60
    })
    
    edit_name('Hello')
    edit_description('How are things')
    edit_interval(3)
    switch_active
    
    tap view('Save')
    controller.instance_variable_get(:@created).should == true
  end
end
