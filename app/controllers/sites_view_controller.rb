class SitesViewController < UITableViewController
  attr_accessor :sites
  
  def init
    self.sites = []
    super
  end
  
  def viewDidLoad
    self.title = "Sites"
    Site.find_all do |results|
      self.sites = results
      tableView.reloadData
    end
    
    @menu_button = UIBarButtonItem.alloc.initWithTitle("Menu", style:UIBarButtonItemStyleBordered, target:self.viewDeckController, action:'toggleLeftView')
    self.navigationItem.leftBarButtonItem = @menu_button
    
    @plus_button = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemAdd, target:self, action:'add')
    self.navigationItem.rightBarButtonItem = @plus_button
  end
  
  def viewWillAppear(animated)
    super
    tableView.reloadData
  end
  
  def numberOfSectionsInTableView(tableView)
    1
  end
  
  def tableView(tableView, numberOfRowsInSection:section)
    self.sites.size
  end
  
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier('Cell')
    cell ||= UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:'Cell')
    
    site = sites[indexPath.row]
    cell.textLabel.text = site.name
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
    cell.imageView.image = UIImage.imageNamed("#{site.status}.png")
    cell
  end
  
  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    navigationController.pushViewController(SiteViewController.alloc.initWithSite(sites[indexPath.row], parent:self), animated:true)
  end
  
  def add
    navigationController.pushViewController(SiteViewController.alloc.initWithParent(self), animated:true)
  end
end
