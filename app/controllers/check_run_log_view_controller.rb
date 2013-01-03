class CheckRunLogViewController < UITableViewController
  attr_accessor :check_run
  
  def initWithCheckRun(check_run)
    @check_run = check_run
    init
  end
  
  def viewDidLoad
    self.title = "Log"
  end
  
  def tableView(tableView, numberOfRowsInSection:section)
    @check_run.log.size
  end
  
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    fresh_cell.tap do |cell|
      cell.textLabel.text = check_run.log[indexPath.row].last
      cell.detailTextLabel.text = check_run.log[indexPath.row].first
    end
  end
  
  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    navigationController.pushViewController(CheckRunLogEntryViewController.alloc.initWithCheckRun(check_run, index:indexPath.row), animated:true)
  end

private
  def fresh_cell
    tableView.dequeueReusableCellWithIdentifier('Cell') ||
    UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:'Cell').tap do |cell|
      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
    end
  end
end
