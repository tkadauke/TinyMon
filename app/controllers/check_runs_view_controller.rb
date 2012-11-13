class CheckRunsViewController < UITableViewController
  attr_accessor :health_check
  attr_accessor :check_runs
  
  def initWithHealthCheck(health_check)
    self.health_check = health_check
    self.check_runs = []
    init
  end
  
  def viewDidLoad
    self.title = "Check Runs"
    health_check.check_runs do |results|
      self.check_runs = results
      tableView.reloadData
    end
  end
  
  def numberOfSectionsInTableView(tableView)
    1
  end
  
  def tableView(tableView, numberOfRowsInSection:section)
    self.check_runs.size
  end
  
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier('Cell')
    cell ||= UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:'Cell')
    
    cell.textLabel.text = check_runs[indexPath.row].created_at
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
    cell
  end
  
  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    navigationController.pushViewController(CheckRunViewController.alloc.initWithCheckRun(check_runs[indexPath.row]), animated:true)
  end
end
