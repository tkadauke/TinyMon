class UserAccountsViewController < UITableViewController
  include Refreshable
  include RootController
  
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
    self.user_accounts.size
  end
  
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier('Cell')
    cell ||= UserTableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:'Cell')
    
    cell.user_account = user_accounts[indexPath.row]
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
    cell
  end
  
  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    navigationController.pushViewController(UserViewController.alloc.initWithUser(user_accounts[indexPath.row].user), animated:true)
  end
  
  def load_data
    TinyMon.when_reachable do
      SVProgressHUD.showWithMaskType(SVProgressHUDMaskTypeClear)
      UserAccount.find_all(:account_id => Account.current.id) do |results|
        SVProgressHUD.dismiss
        if results
          self.user_accounts = results
        else
          TinyMon.offline_alert
        end
        tableView.reloadData
        end_refreshing
      end
    end
  end
end
