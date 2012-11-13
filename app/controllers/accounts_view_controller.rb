class AccountsViewController < UITableViewController
  attr_accessor :accounts
  
  def init
    self.accounts = []
    super
  end
  
  def viewDidLoad
    self.title = "Accounts"
    Account.find_all do |results|
      self.accounts = results
      tableView.reloadData
    end
    
    @menu_button = UIBarButtonItem.alloc.initWithTitle("Menu", style:UIBarButtonItemStyleBordered, target:self.viewDeckController, action:'toggleLeftView')
    self.navigationItem.leftBarButtonItem = @menu_button
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
end
