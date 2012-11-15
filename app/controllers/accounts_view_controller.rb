class AccountsViewController < UITableViewController
  include Refreshable
  include RootController
  include LoadingController
  
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
    if loading
      1
    else
      self.accounts.size
    end
  end
  
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    if loading
      loading_cell
    else
      cell = tableView.dequeueReusableCellWithIdentifier('Cell')
      cell ||= UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:'Cell')
    
      cell.textLabel.text = accounts[indexPath.row].name
      cell
    end
  end
  
  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    return if loading
    accounts[indexPath.row].switch do
      self.viewDeckController.centerController = LoggedInNavigationController.alloc.initWithRootViewController(RecentCheckRunsViewController.alloc.init)
    end
  end
  
  def load_data
    TinyMon.when_reachable do
      Account.find_all do |results|
        if results
          self.accounts = results
        else
          TinyMon.offline_alert
        end
        done_loading
        end_refreshing
      end
    end
  end
end
