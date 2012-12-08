class SitesViewController < UITableViewController
  include Refreshable
  include RootController
  
  attr_reader :search_bar
  attr_accessor :sites
  attr_accessor :filtered_sites
  
  def init
    self.sites = []
    self.filtered_sites = []
    super
  end
  
  def viewDidLoad
    self.title = "Sites"
    self.toolbarItems = toolbar_items

    @search_bar = UISearchBar.alloc.initWithFrame([[0, 0], [320, 44]])
    @search_bar.delegate = self
    tableView.tableHeaderView = @search_bar
    search_controller = UISearchDisplayController.alloc.initWithSearchBar(@search_bar, contentsController:self)
    search_controller.delegate = self
    search_controller.searchContentsController = self
    search_controller.searchResultsDataSource = self
    search_controller.searchResultsDelegate = self
    self.searchDisplayController = search_controller
    
    load_data
    
    if User.current.can_create_sites?
      @plus_button = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemAdd, target:self, action:'add')
      self.navigationItem.rightBarButtonItem = @plus_button
    end
    
    on_refresh do
      load_data
    end
    
    super
  end
  
  def viewWillAppear(animated)
    super
    tableView.reloadData
  end
  
  def tableView(tableView, numberOfRowsInSection:section)
    self.filtered_sites.size
  end
  
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier('Cell')
    cell ||= UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:'Cell')
    
    site = self.filtered_sites[indexPath.row]
    cell.textLabel.text = site.name
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
    cell.imageView.image = UIImage.imageNamed("#{site.status}.png")
    cell
  end
  
  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    navigationController.pushViewController(SiteViewController.alloc.initWithSite(self.filtered_sites[indexPath.row], parent:self), animated:true)
  end
  
  def searchDisplayController(controller, shouldReloadTableForSearchString:string)
    self.filter_search(string, animated:false)
    true
  end
  
  def filter_search(string, animated:animated)
    string ||= @search_bar.text || ""
    string = string.downcase
    
    self.filtered_sites = case @filter.selectedSegmentIndex
    when 0
      self.sites
    when 1
      self.sites.select { |x| x.status == 'success' }
    when 2
      self.sites.select { |x| x.status == 'failure' }
    end
    self.filtered_sites = self.filtered_sites.select { |s| s.name.downcase.include?(string) } unless string.blank?
    
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
    navigationController.pushViewController(SiteViewController.alloc.initWithParent(self), animated:true)
  end
  
  def load_data
    TinyMon.when_reachable do
      SVProgressHUD.showWithMaskType(SVProgressHUDMaskTypeClear)
      Site.find_all do |results, response|
        SVProgressHUD.dismiss
        if response.ok? && results
          self.sites = results
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
    ["All", "Success", "Failure"]
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
