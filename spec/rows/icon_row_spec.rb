describe "IconRow" do
  before do
    @row = Formotion::Row.new(type: :icon, key: :icon, title: "Icon")
    @row.reuse_identifier = 'test'
  end
  
  it "should have an icon if value is set" do
    @row.value = UIImage.imageNamed('success.png')
    cell = @row.make_cell
    image_view = cell.viewWithTag(Formotion::RowType::ICON_VIEW_TAG)
    image_view.image.should.not.be.nil
  end
  
  it "should not have an icon if value is unset" do
    cell = @row.make_cell
    image_view = cell.viewWithTag(Formotion::RowType::ICON_VIEW_TAG)
    image_view.image.should.be.nil
  end
end
