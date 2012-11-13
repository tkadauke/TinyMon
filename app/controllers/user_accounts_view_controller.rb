class UserAccountsViewController < UITableViewController
  include Refreshable
  
  attr_accessor :user_accounts
  
  def init
    self.user_accounts = []
    super
  end
  
  def viewDidLoad
    self.title = "Users"
    
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
  
  def load_data
    UserAccount.find_all(:account_id => Account.current_account_id) do |results|
      self.user_accounts = results
      tableView.reloadData
      end_refreshing
    end
  end
end
