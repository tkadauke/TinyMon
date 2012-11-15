class SitesViewController < UITableViewController
  include Refreshable
  include RootController
  include LoadingController
  
  attr_accessor :sites
  
  def init
    self.sites = []
    super
  end
  
  def viewDidLoad
    self.title = "Sites"
    load_data
    
    @plus_button = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemAdd, target:self, action:'add')
    self.navigationItem.rightBarButtonItem = @plus_button
    
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
    if loading
      1
    else
      self.sites.size
    end
  end
  
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    if loading
      loading_cell
    else
      cell = tableView.dequeueReusableCellWithIdentifier('Cell')
      cell ||= UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:'Cell')
    
      site = sites[indexPath.row]
      cell.textLabel.text = site.name
      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
      cell.imageView.image = UIImage.imageNamed("#{site.status}.png")
      cell
    end
  end
  
  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    return if loading
    navigationController.pushViewController(SiteViewController.alloc.initWithSite(sites[indexPath.row], parent:self), animated:true)
  end
  
  def add
    navigationController.pushViewController(SiteViewController.alloc.initWithParent(self), animated:true)
  end
  
  def load_data
    TinyMon.when_reachable do
      Site.find_all do |results|
        if results
          self.sites = results
        else
          TinyMon.offline_alert
        end
        done_loading
        end_refreshing
      end
    end
  end
end
