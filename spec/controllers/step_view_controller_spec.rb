module StepViewControllerHelper
  def edit_field(name, value)
    cell = view(name)
    tap cell
    field = cell.up(UITableViewCell).viewsByClass(UITextField).first
    field.text = value
    field.resignFirstResponder
  end
end

describe StepViewController do
  extend WebStub::SpecHelpers
  extend MotionResource::SpecHelpers
  extend StepViewControllerHelper
  
  before do
    Account.current = Account.instantiate(:id => 5, :role => 'user')
    User.current = User.instantiate(:id => 1, :role => 'user')
    
    @health_check = HealthCheck.instantiate(
      :id => 30,
      :permalink => 'test',
      :site => {
        :id => 10,
        :permalink => 'test-site',
        :account_id => 10
      }
    )

    self.controller = StepViewController.alloc.initWithStep(FillInStep.new(:health_check => @health_check, :type => 'FillInStep'), parent:nil)
  end
  
  tests StepViewController
  
  it "should show field cell" do
    view('Field').should.not.be.nil
  end
  
  it "should show value cell" do
    view('Value').should.not.be.nil
  end
  
  it "should edit field" do
    edit_field('Field', 'username')
    controller.form.render[:field].should == 'username'
    controller.model.field.should == 'username'
  end
  
  it "should edit value" do
    edit_field('Value', 'johndoe')
    controller.form.render[:value].should == 'johndoe'
    controller.model.value.should == 'johndoe'
  end
  
  it "should create step" do
    controller.navigationController.stub!(:viewControllers, :return => [])
    controller.navigationController.mock!(:popToViewController)
    stub_request(:post, 'http://mon.tinymon.org/en/accounts/10/sites/test-site/health_checks/test/steps.json?type=fill_in').to_return(json: {
      :id => 30,
      :type => 'FillInStep',
      :data => {
        :field => 'username',
        :value => 'johndoe'
      }
    })
    
    edit_field('Field', 'username')
    edit_field('Value', 'johndoe')
    
    tap view('Save')
    controller.instance_variable_get(:@created).should == true
  end
end

describe StepViewController do
  extend WebStub::SpecHelpers
  extend MotionResource::SpecHelpers
  extend StepViewControllerHelper
  
  before do
    Account.current = Account.instantiate(:id => 5, :role => 'user')
    User.current = User.instantiate(:id => 1, :role => 'user')
    
    @health_check = HealthCheck.instantiate(
      :id => 30,
      :permalink => 'test',
      :site => {
        :id => 10,
        :permalink => 'test-site',
        :account_id => 10
      }
    )
    
    @step = FillInStep.instantiate(:id => 10, :health_check => @health_check, :type => 'FillInStep')

    self.controller = StepViewController.alloc.initWithStep(@step, parent:nil)
  end
  
  tests StepViewController

  it "should show field cell" do
    view('Field').should.not.be.nil
  end
  
  it "should show value cell" do
    view('Value').should.not.be.nil
  end
  
  it "should edit field" do
    edit_field('Field', 'username')
    controller.form.render[:field].should == 'username'
    @step.field.should == 'username'
  end
  
  it "should edit value" do
    edit_field('Value', 'johndoe')
    controller.form.render[:value].should == 'johndoe'
    @step.value.should == 'johndoe'
  end
  
  it "should save changes" do
    controller.navigationController.mock!(:popViewControllerAnimated)
    stub_request(:put, 'http://mon.tinymon.org/en/accounts/10/sites/test-site/health_checks/test/steps/10.json').to_return(json: {})
    
    edit_field('Field', 'username')
    edit_field('Value', 'janedoe')
    
    tap view('Save')
    1.should == 1
  end
  
  it "should delete step" do
    controller.navigationController.mock!(:popViewControllerAnimated)
    stub_request(:delete, 'http://mon.tinymon.org/en/accounts/10/sites/test-site/health_checks/test/steps/10.json').to_return(json: { id: 30 })
    tap view('Delete')
    tap controller.instance_variable_get(:@action_sheet).viewByName('Yes, delete')
    controller.instance_variable_get(:@deleted).should == true
  end
  
  it "should not delete step when canceled" do
    tap view('Delete')
    tap controller.instance_variable_get(:@action_sheet).viewByName('No')
    controller.instance_variable_get(:@deleted).should.be.nil
  end
end
