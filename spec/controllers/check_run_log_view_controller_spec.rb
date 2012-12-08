describe CheckRunLogViewController do
  extend WebStub::SpecHelpers
  extend MotionResource::SpecHelpers
  
  before do
    check_run = CheckRun.new(
      :log => [
        [ '2012-01-01 00:00:00', 'Nothing happened' ],
        [ '2012-01-01 00:00:05', 'Something happened' ],
        [ '2012-01-01 00:00:10', 'Something else happened' ]
      ]
    )
    self.controller = CheckRunLogViewController.alloc.initWithCheckRun(check_run)
  end
  
  tests CheckRunLogViewController
  
  it "should show timestamps" do
    view('2012-01-01 00:00:00').should.not.be.nil
    view('2012-01-01 00:00:05').should.not.be.nil
  end
  
  it "should show log entries" do
    view('Nothing happened').should.not.be.nil
    view('Something happened').should.not.be.nil
  end
  
  it "should show disclosure indicator" do
    view('Nothing happened').superview.superview.accessoryType.should == UITableViewCellAccessoryDisclosureIndicator
  end
  
  it "should disclose log entry" do
    controller.navigationController.mock!(:pushViewController)
    tap view('Nothing happened')
    
    1.should == 1
  end
end
