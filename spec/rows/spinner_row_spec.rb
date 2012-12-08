describe "SpinnerRow" do
  before do
    @row = Formotion::Row.new(type: :spinner, key: :spinner, title: "Spinner")
    @row.reuse_identifier = 'test'
  end
  
  it "should not be selectable" do
    cell = @row.make_cell
    cell.selectionStyle.should == UITableViewCellSelectionStyleNone
  end
  
  it "should have a spinner" do
    cell = @row.make_cell
    cell.accessoryView.class.should == UIActivityIndicatorView
  end
end
