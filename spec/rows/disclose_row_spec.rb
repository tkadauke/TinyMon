describe "DiscloseRow" do
  before do
    @row = Formotion::Row.new(type: :disclose, key: :disclose, title: "Disclose")
    @row.reuse_identifier = 'test'
  end
  
  it "should be have disclose indicator" do
    cell = @row.make_cell
    cell.accessoryType.should == UITableViewCellAccessoryDisclosureIndicator
  end
  
  it "should trigger select callback" do
    triggered = false
    
    form = Formotion::Form.new
    form.on_select do
      triggered = true
    end
    
    @row.object.on_select(nil, form)
    triggered.should == true
  end
  
  it "should not crash when triggered and no select callback is set" do
    lambda do
      form = Formotion::Form.new
      @row.object.on_select(nil, form)
    end.should.not.raise
  end
end
