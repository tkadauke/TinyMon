class SitesViewController < UITableViewController
  include Refreshable
  include RootController
  
  attr_accessor :sites
  attr_accessor :all_sites
  
  def init
    self.sites = []
    super
  end
  
  def viewDidLoad
    self.title = "Sites"
    self.toolbarItems = toolbar_items

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
  
  def load_data
    TinyMon.when_reachable do
      SVProgressHUD.showWithMaskType(SVProgressHUDMaskTypeClear)
      Site.find_all do |results|
        SVProgressHUD.dismiss
        if results
          self.all_sites = results
          self.change_filter(@filter)
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
    case sender.selectedSegmentIndex
    when 0
      self.sites = self.all_sites
    when 1
      self.sites = self.all_sites.select { |x| x.status == 'success' }
    when 2
      self.sites = self.all_sites.select { |x| x.status == 'failure' }
    end
    self.tableView.reloadSections(NSIndexSet.indexSetWithIndex(0), withRowAnimation:UITableViewRowAnimationFade)
  end
end
