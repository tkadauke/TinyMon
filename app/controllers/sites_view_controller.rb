class SitesViewController < UITableViewController
  include Refreshable
  include RootController
  
  attr_reader :search_bar
  attr_accessor :sites
  attr_accessor :filtered_sites
  
  def init
    @sites = []
    @filtered_sites = []
    super
  end
  
  def viewDidLoad
    self.title = "Sites"
    self.toolbarItems = toolbar_items

    tableView.tableHeaderView = build_search_bar
    self.searchDisplayController = build_search_controller
    
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
    @filtered_sites.size
  end
  
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier('Cell')
    cell ||= UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:'Cell')
    
    site = @filtered_sites[indexPath.row]
    cell.textLabel.text = site.name
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
    cell.imageView.image = UIImage.imageNamed("#{site.status}.png")
    cell
  end
  
  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    navigationController.pushViewController(SiteViewController.alloc.initWithSite(@filtered_sites[indexPath.row], parent:self), animated:true)
  end
  
  def searchDisplayController(controller, shouldReloadTableForSearchString:string)
    self.filter_search(string, animated:false)
    true
  end
  
  def filter_search(string, animated:animated)
    string ||= @search_bar.text || ""
    string = string.downcase
    
    @filtered_sites = case @filter.selectedSegmentIndex
    when 0
      @sites
    when 1
      @sites.select { |x| x.status == 'success' }
    when 2
      @sites.select { |x| x.status == 'failure' }
    end
    @filtered_sites = @filtered_sites.select { |s| s.name.downcase.include?(string) } unless string.blank?
    
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
          @sites = results
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
 
    [space, filter_button_item, space]
  end
  
  def change_filter(sender)
    filter_search(nil, animated:true)
  end
  
  def searchBarCancelButtonClicked(searchBar)
    filter_search("", animated:true)
  end

private
  def build_search_controller
    UISearchDisplayController.alloc.initWithSearchBar(@search_bar, contentsController:self).tap do |controller|
      controller.delegate = self
      controller.searchContentsController = self
      controller.searchResultsDataSource = self
      controller.searchResultsDelegate = self
    end
  end
  
  def build_search_bar
    @search_bar = UISearchBar.alloc.initWithFrame([[0, 0], [320, 44]])
    @search_bar.delegate = self
    @search_bar
  end
  
  def filter_button_item
    @filter = UISegmentedControl.alloc.initWithItems(filter_items)
    @filter.segmentedControlStyle = UISegmentedControlStyleBar
    @filter.selectedSegmentIndex = 0
    @filter.addTarget(self, action:"change_filter:", forControlEvents:UIControlEventValueChanged)
 
    UIBarButtonItem.alloc.initWithCustomView(@filter)
  end
end
