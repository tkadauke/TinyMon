describe "LabelRow" do
  before do
    @row = Formotion::Row.new(type: :label, key: :label, title: "Label")
    @row.reuse_identifier = 'test'
  end
  
  it "should not be selectable" do
    cell = @row.make_cell
    cell.selectionStyle.should == UITableViewCellSelectionStyleNone
  end
end
