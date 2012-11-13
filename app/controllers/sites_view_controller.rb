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
    
    cell.textLabel.text = sites[indexPath.row].name
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
    cell
  end
  
  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    navigationController.pushViewController(SiteViewController.alloc.initWithSite(sites[indexPath.row], parent:self), animated:true)
  end
  
  def add
    navigationController.pushViewController(SiteViewController.alloc.initWithParent(self), animated:true)
  end
end
