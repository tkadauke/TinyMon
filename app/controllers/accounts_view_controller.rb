class AccountsViewController < UITableViewController
  include Refreshable
  include RootController
  
  attr_accessor :accounts
  
  def init
    self.accounts = []
    super
  end
  
  def viewDidLoad
    self.title = "Accounts"
    
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
      self.viewDeckController.centerController = LoggedInNavigationController.alloc.initWithRootViewController(RecentCheckRunsViewController.alloc.init)
    end
  end
  
  def load_data
    TinyMon.when_reachable do
      SVProgressHUD.showWithMaskType(SVProgressHUDMaskTypeClear)
      Account.find_all do |results|
        SVProgressHUD.dismiss
        if results
          self.accounts = results
        else
          TinyMon.offline_alert
        end
        tableView.reloadData
        end_refreshing
      end
    end
  end
end
