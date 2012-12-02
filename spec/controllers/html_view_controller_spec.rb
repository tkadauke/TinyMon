describe HtmlViewController do
  before do
    self.controller = HtmlViewController.alloc.initWithHTML('Whats up?', title:'Hello')
  end
  
  tests HtmlViewController
  
  it "should show HTML" do
    content.should == 'Whats up?'
  end
  
  it "should change HTML" do
    controller.html = 'Hello world'
    controller.reload_content
    content.should == 'Hello world'
  end

  def content
    result = nil
    RunLoopHelpers.wait_till do
      result = controller.view.stringByEvaluatingJavaScriptFromString("document.documentElement.innerText;")
      result.present?
    end
    result
  end
end
