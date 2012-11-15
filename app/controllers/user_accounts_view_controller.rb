class UserAccountsViewController < UITableViewController
  include Refreshable
  include RootController
  include LoadingController
  
  attr_accessor :user_accounts
  
  def init
    self.user_accounts = []
    super
  end
  
  def viewDidLoad
    self.title = "Users"
    
    load_data
    
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
      self.user_accounts.size
    end
  end
  
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    if loading
      loading_cell
    else
      cell = tableView.dequeueReusableCellWithIdentifier('Cell')
      cell ||= UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:'Cell')
    
      user_account = user_accounts[indexPath.row]
      cell.textLabel.text = user_account.user.full_name
      cell.detailTextLabel.text = user_account.role
      cell
    end
  end
  
  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    return if loading
    tableView.deselectRowAtIndexPath(indexPath, animated:true)
  end
  
  def load_data
    TinyMon.when_reachable do
      UserAccount.find_all(:account_id => Account.current_account_id) do |results|
        if results
          self.user_accounts = results
        else
          TinyMon.offline_alert
        end
        done_loading
        end_refreshing
      end
    end
  end
end
