class CheckRunLogViewController < UITableViewController
  attr_accessor :check_run
  
  def initWithCheckRun(check_run)
    self.check_run = check_run
    init
  end
  
  def viewDidLoad
    self.title = "Log"
  end
  
  def tableView(tableView, numberOfRowsInSection:section)
    self.check_run.log.size
  end
  
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier('Cell')
    cell ||= UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:'Cell')
    
    cell.textLabel.text = check_run.log[indexPath.row].last
    cell.detailTextLabel.text = check_run.log[indexPath.row].first
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
    cell
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    navigationController.pushViewController(CheckRunLogEntryViewController.alloc.initWithCheckRun(check_run, index:indexPath.row), animated:true)
  end
end
