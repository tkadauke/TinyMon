class HealthChecksViewController < UITableViewController
  include Refreshable
  
  attr_accessor :site
  attr_accessor :health_checks
  attr_accessor :filtered_health_checks
  
  def init
    $h=self
    self.health_checks = []
    self.filtered_health_checks = []
    super
  end
  
  def initWithSite(site)
    self.site = site
    init
  end
  
  def viewDidLoad
    self.title = "Health Checks"
    self.toolbarItems = toolbar_items
    
    @search_bar = UISearchBar.alloc.initWithFrame([[0, 0], [320, 44]])
    @search_bar.delegate = self
    tableView.tableHeaderView = @search_bar
    search_controller = UISearchDisplayController.alloc.initWithSearchBar(@search_bar, contentsController:self)
    search_controller.delegate = self
    search_controller.searchContentsController = self
    search_controller.searchResultsDataSource = self
    search_controller.searchResultsDelegate = self
    search_controller.searchResultsTableView.backgroundColor = UIColor.whiteColor
    self.searchDisplayController = search_controller
    
    load_data
    
    if User.current.can_create_health_checks?
      @plus_button = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemAdd, target:self, action:'add')
      self.navigationItem.rightBarButtonItem = @plus_button
    end
    
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
    self.filtered_health_checks.size
  end
  
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier('Cell')
    cell ||= UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:'Cell')
    
    health_check = filtered_health_checks[indexPath.row]
    cell.textLabel.text = health_check.name
    detail_info = [health_check.site.name]
    detail_info << Time.future_in_words(health_check.next_check_at_to_now) if health_check.enabled
    cell.detailTextLabel.text = detail_info.join(", ")
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
    cell.imageView.image = UIImage.imageNamed("#{health_check.status_icon}.png")
    cell
  end
  
  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    navigationController.pushViewController(HealthCheckViewController.alloc.initWithHealthCheck(filtered_health_checks[indexPath.row], parent:self), animated:true)
  end
  
  def searchDisplayController(controller, shouldReloadTableForSearchString:string)
    self.filter_search(string, animated:false)
    true
  end
  
  def filter_search(string, animated:animated)
    string ||= @search_bar.text || ""
    string = string.downcase
    
    self.filtered_health_checks = case @filter.selectedSegmentIndex
    when 0
      self.health_checks
    when 1
      self.health_checks.select { |x| x.status == 'success' && x.enabled == true }
    when 2
      self.health_checks.select { |x| x.status == 'failure' && x.enabled == true }
    when 3
      self.health_checks.select { |x| x.enabled == true }
    when 4
      self.health_checks.select { |x| x.enabled == false }
    end
    self.filtered_health_checks = self.filtered_health_checks.select { |h| h.name.downcase.include?(string) } unless string.blank?
    
    if animated
      if self.searchDisplayController.isActive
        searchDisplayController.searchResultsTableView.reloadSections(NSIndexSet.indexSetWithIndex(0), withRowAnimation:UITableViewRowAnimationFade)
      else
        self.tableView.reloadSections(NSIndexSet.indexSetWithIndex(0), withRowAnimation:UITableViewRowAnimationFade)
      end
    else
      if self.searchDisplayController.isActive
        searchDisplayController.searchResultsTableView.reloadData
      else
        self.tableView.reloadData
      end
    end
  end
  
  def add
    navigationController.pushViewController(HealthCheckViewController.alloc.initWithSite(site, parent:self), animated:true)
  end
  
  def load_data
    TinyMon.when_reachable do
      SVProgressHUD.showWithMaskType(SVProgressHUDMaskTypeClear)
      site.health_checks do |results|
        SVProgressHUD.dismiss
        if results
          self.health_checks = results
          self.filter_search("", animated:false)
        else
          TinyMon.offline_alert
        end
        tableView.reloadData
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
    filter_search(nil, animated:true)
  end
  
  def searchBarCancelButtonClicked(searchBar)
    filter_search("", animated:true)
  end
end
