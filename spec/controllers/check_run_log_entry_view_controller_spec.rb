describe CheckRunLogEntryViewController do
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
    self.controller = CheckRunLogEntryViewController.alloc.initWithCheckRun(check_run, index: 1)
  end
  
  tests CheckRunLogEntryViewController
  
  it "should have current index in the title" do
    (controller.title =~ /2 of 3/).should.not.be.nil
  end
  
  it "should show log entry" do
    content.should == 'Something happened'
  end
  
  it "should go to next log entry" do
    content
    down
    content.should == "Something else happened"
  end
  
  it "should go to previous log entry" do
    content
    up
    content.should == "Nothing happened"
  end
  
  it "should update title for next log entry" do
    down
    (controller.title =~ /3 of 3/).should.not.be.nil
  end
  
  it "should update title previous log entry" do
    up
    (controller.title =~ /1 of 3/).should.not.be.nil
  end
  
  def content
    result = nil
    RunLoopHelpers.wait_till do
      result = controller.view.stringByEvaluatingJavaScriptFromString("document.documentElement.innerText;")
      result.present?
    end
    result
  end
  
  def up
    sender = Object.new
    def sender.selectedSegmentIndex; 0; end
    controller.up_down(sender)
  end
  
  def down
    sender = Object.new
    def sender.selectedSegmentIndex; 1; end
    controller.up_down(sender)
  end
end
