Teacup::Stylesheet.new :logged_in_menu_sheet do
  style :table,
    backgroundColor: UIColor.colorWithRed(50.0/255, green: 57.0/255, blue: 73.0/255, alpha:1),
    separatorStyle: UITableViewCellSeparatorStyleNone,
    sectionHeaderHeight: 30
  
  style :cell,
    textColor: UIColor.colorWithRed(196.0/255, green: 204.0/255, blue: 218.0/255, alpha:1),
    accessoryType: UITableViewCellAccessoryDisclosureIndicator
  
  style :selected,
    backgroundColor: UIColor.colorWithRed(36.0/255, green: 42.0/255, blue: 55.0/255, alpha:1)
  
  style :top_line,
    width: '100%',
    height: 1,
    backgroundColor: UIColor.colorWithRed(62.0/255, green: 69.0/255, blue: 85.0/255, alpha:1),
    autoresizingMask: UIViewAutoresizingFlexibleWidth
  
  style :bottom_line,
    width: '100%',
    height: 1,
    top: lambda { superview.bounds.size.height - 1 },
    backgroundColor: UIColor.colorWithRed(36.0/255, green: 42.0/255, blue: 55.0/255, alpha:1),
    autoresizingMask: UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth
end
