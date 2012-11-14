class HealthChecksViewController < UITableViewController
  include Refreshable
  
  attr_accessor :site
  attr_accessor :health_checks
  
  def initWithSite(site)
    self.site = site
    self.health_checks = []
    init
  end
  
  def viewDidLoad
    self.title = "Health Checks"
    load_data
    
    @plus_button = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemAdd, target:self, action:'add')
    self.navigationItem.rightBarButtonItem = @plus_button
    
    on_refresh do
      site.reset_health_checks
      load_data
    end
    
    super
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
    
    health_check = health_checks[indexPath.row]
    cell.textLabel.text = health_check.name
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
    cell.imageView.image = UIImage.imageNamed("#{health_check.status_icon}.png")
    cell
  end
  
  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    navigationController.pushViewController(HealthCheckViewController.alloc.initWithHealthCheck(health_checks[indexPath.row], parent:self), animated:true)
  end
  
  def add
    navigationController.pushViewController(HealthCheckViewController.alloc.initWithSite(site, parent:self), animated:true)
  end
  
  def load_data
    TinyMon.when_reachable do
      site.health_checks do |results|
        if results
          self.health_checks = results
          tableView.reloadData
        else
          TinyMon.offline_alert
        end
        end_refreshing
      end
    end
  end
end
