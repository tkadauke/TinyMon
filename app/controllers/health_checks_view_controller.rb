class HealthChecksViewController < UITableViewController
  include Refreshable
  include LoadingController
  
  attr_accessor :site
  attr_accessor :health_checks
  attr_accessor :all_health_checks
  
  def init
    self.health_checks = []
    super
  end
  
  def initWithSite(site)
    self.site = site
    init
  end
  
  def viewDidLoad
    self.title = "Health Checks"
    self.toolbarItems = toolbar_items
    
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
    if loading
      1
    else
      self.health_checks.size
    end
  end
  
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    if loading
      loading_cell
    else
      cell = tableView.dequeueReusableCellWithIdentifier('Cell')
      cell ||= UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:'Cell')
    
      health_check = health_checks[indexPath.row]
      cell.textLabel.text = health_check.name
      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
      cell.imageView.image = UIImage.imageNamed("#{health_check.status_icon}.png")
      cell
    end
  end
  
  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    return if loading
    navigationController.pushViewController(HealthCheckViewController.alloc.initWithHealthCheck(health_checks[indexPath.row], parent:self), animated:true)
  end
  
  def add
    navigationController.pushViewController(HealthCheckViewController.alloc.initWithSite(site, parent:self), animated:true)
  end
  
  def load_data
    TinyMon.when_reachable do
      site.health_checks do |results|
        if results
          self.all_health_checks = results
          self.change_filter(@filter)
        else
          TinyMon.offline_alert
        end
        done_loading
        end_refreshing
      end
    end
  end
  
  def filter_items
    ["All", "Success", "Failure", "Enabled", "Disabled"]
  end
  
  def toolbar_items
    space = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemFlexibleSpace, target:nil, action:nil)
 
    @filter = UISegmentedControl.alloc.initWithItems(filter_items)
    @filter.segmentedControlStyle = UISegmentedControlStyleBar
    @filter.selectedSegmentIndex = 0
    @filter.addTarget(self, action:"change_filter:", forControlEvents:UIControlEventValueChanged)
 
    filter_button_item = UIBarButtonItem.alloc.initWithCustomView(@filter)
    
    [space, filter_button_item, space]
  end
  
  def change_filter(sender)
    case sender.selectedSegmentIndex
    when 0
      self.health_checks = self.all_health_checks
    when 1
      self.health_checks = self.all_health_checks.select { |x| x.status == 'success' }
    when 2
      self.health_checks = self.all_health_checks.select { |x| x.status == 'failure' }
    when 3
      self.health_checks = self.all_health_checks.select { |x| x.enabled == true }
    when 4
      self.health_checks = self.all_health_checks.select { |x| x.enabled == false }
    end
    self.tableView.reloadSections(NSIndexSet.indexSetWithIndex(0), withRowAnimation:UITableViewRowAnimationFade)
  end
end
