class HealthChecksViewController < UITableViewController
  attr_accessor :site
  attr_accessor :health_checks
  
  def initWithSite(site)
    self.site = site
    self.health_checks = []
    init
  end
  
  def viewDidLoad
    self.title = "Health Checks"
    site.health_checks do |results|
      self.health_checks = results
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
    self.health_checks.size
  end
  
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier('Cell')
    cell ||= UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:'Cell')
    
    cell.textLabel.text = health_checks[indexPath.row].name
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
    cell
  end
  
  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    navigationController.pushViewController(HealthCheckViewController.alloc.initWithHealthCheck(health_checks[indexPath.row], parent:self), animated:true)
  end
  
  def add
    navigationController.pushViewController(HealthCheckViewController.alloc.initWithSite(site, parent:self), animated:true)
  end
end
