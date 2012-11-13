class UserAccountsViewController < UITableViewController
  attr_accessor :user_accounts
  
  def init
    self.user_accounts = []
    super
  end
  
  def viewDidLoad
    self.title = "Users"
    UserAccount.find_all(:account_id => Account.current_account_id) do |results|
      self.user_accounts = results
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
    self.user_accounts.size
  end
  
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier('Cell')
    cell ||= UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:'Cell')
    
    user_account = user_accounts[indexPath.row]
    cell.textLabel.text = user_account.user.full_name
    cell.detailTextLabel.text = user_account.role
    cell
  end
  
  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    tableView.deselectRowAtIndexPath(indexPath, animated:true)
  end
end
