describe "DeleteRow" do
  before do
    @row = Formotion::Row.new(type: :delete, key: :delete, title: "Delete")
    @row.reuse_identifier = 'test'
  end
  
  it "should be red" do
    cell = @row.make_cell
    cell.backgroundColor.should == UIColor.redColor
  end
  
  it "should trigger delete callback" do
    triggered = false
    
    form = Formotion::Form.new
    form.on_delete do
      triggered = true
    end
    
    @row.object.on_select(nil, form)
    triggered.should == true
  end
  
  it "should not crash when triggered and no delete callback is set" do
    lambda do
      form = Formotion::Form.new
      @row.object.on_select(nil, form)
    end.should.not.raise
  end
end
