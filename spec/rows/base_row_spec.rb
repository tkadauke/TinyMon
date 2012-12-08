describe "BaseRow" do
  before do
    @row = Formotion::Row.new(type: :static, key: :static, title: "Static")
    @row.reuse_identifier = 'test'
  end
  
  it "should have a nice style" do
    @row.object.cell_style.should == UITableViewCellStyleValue1
  end
end