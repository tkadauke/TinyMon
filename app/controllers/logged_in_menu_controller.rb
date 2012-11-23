class LoggedInMenuController < UITableViewController
  stylesheet :logged_in_menu_sheet
  
  ITEMS = [{
    title: "Monitoring",
    rows: [{
      title: "Activity",
      key: :activity
    }, {
      title: "Sites",
      key: :sites
    }, {
      title: "Health Checks",
      key: :health_checks
    }]
  }, {
    title: "Account",
    rows: [{
      title: "Switch account",
      key: :accounts
    }, {
      title: "Users",
      key: :users
    }]
  }, {
    title: "General",
    rows: [{
      title: "Log out",
      key: :logout
    }]
  }]
  
  def init
    super
    layout tableView, :table
    self
  end
  
  def numberOfSectionsInTableView(tableView)
    ITEMS.size
  end

  def tableView(tableView, numberOfRowsInSection:section)
    ITEMS[section][:rows].size
  end

  def tableView(tableView, titleForHeaderInSection:section)
    ITEMS[section][:title]
  end
  
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier('Cell')
    cell ||= begin
      cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:'Cell')
      
      layout cell, :cell do
        subview(UIView, :top_line)
        subview(UIView, :bottom_line)
      end
      
      cell.setSelectedBackgroundView(layout(UIView.alloc.init, :selected))
      cell
    end

    cell.textLabel.text = ITEMS[indexPath.section][:rows][indexPath.row][:title]
    cell
  end
  
  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    selected = ITEMS[indexPath.section][:rows][indexPath.row][:key]
    
    viewController = case selected
    when :activity
      RecentCheckRunsViewController.alloc.init
    when :sites
      SitesViewController.alloc.init
    when :health_checks
      AllHealthChecksViewController.alloc.init
    when :accounts
      AccountsViewController.alloc.init
    when :users
      UserAccountsViewController.alloc.init
    when :logout
      logout and return
    else
      SitesViewController.alloc.init
    end
    
    self.viewDeckController.centerController = LoggedInNavigationController.alloc.initWithRootViewController(viewController)
    
    tableView.deselectRowAtIndexPath(indexPath, animated:true)
    self.viewDeckController.toggleLeftView
  end
  
  def logout
    RemoteModule::RemoteModel.default_url_options = nil
    UIApplication.sharedApplication.delegate.window.rootViewController = MonitorNavigationController.alloc.init
  end
end
