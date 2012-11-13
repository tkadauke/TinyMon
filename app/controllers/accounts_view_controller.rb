class AccountsViewController < UITableViewController
  include Refreshable
  
  attr_accessor :accounts
  
  def init
    self.accounts = []
    super
  end
  
  def viewDidLoad
    self.title = "Accounts"
    
    load_data
    
    @menu_button = UIBarButtonItem.alloc.initWithTitle("Menu", style:UIBarButtonItemStyleBordered, target:self.viewDeckController, action:'toggleLeftView')
    self.navigationItem.leftBarButtonItem = @menu_button
    
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
    self.accounts.size
  end
  
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier('Cell')
    cell ||= UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:'Cell')
    
    cell.textLabel.text = accounts[indexPath.row].name
    cell
  end
  
  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    accounts[indexPath.row].switch do
      viewController = SitesViewController.alloc.init
      self.viewDeckController.centerController = LoggedInNavigationController.alloc.initWithRootViewController(viewController)
    end
  end
  
  def load_data
    TinyMon.when_reachable do
      Account.find_all do |results|
        if results
          self.accounts = results
          tableView.reloadData
        else
          TinyMon.offline_alert
        end
        end_refreshing
      end
    end
  end
end
