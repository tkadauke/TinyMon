Teacup::Stylesheet.new :user_cell_sheet do
  style :cell
  
  style :image,
    contentMode: UIViewContentModeScaleAspectFit,
    width: 42,
    height: 42
  
  style :name,
    font: UIFont.boldSystemFontOfSize(17.0),
    textColor: UIColor.blackColor,
    highlightedTextColor: UIColor.whiteColor,
    autoresizingMask: UIViewAutoresizingFlexibleWidth,
    left: 50,
    top: 3,
    width: lambda { superview.bounds.size.width - 66 },
    height: 20
  
  style :role,
    font: UIFont.systemFontOfSize(14.0),
    textColor: UIColor.darkGrayColor,
    highlightedTextColor: UIColor.whiteColor,
    autoresizingMask: UIViewAutoresizingFlexibleWidth,
    left: 50,
    top: 25,
    width: lambda { superview.bounds.size.width - 66 },
    height: 16
end
