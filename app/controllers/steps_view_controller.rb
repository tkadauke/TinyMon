class StepsViewController < UITableViewController
  attr_accessor :health_check
  attr_accessor :steps
  
  def initWithHealthCheck(health_check)
    self.health_check = health_check
    self.steps = []
    init
  end
  
  def viewDidLoad
    self.title = "Steps"
    health_check.steps do |results|
      self.steps = results
      tableView.reloadData
    end
  end
  
  def numberOfSectionsInTableView(tableView)
    1
  end
  
  def tableView(tableView, numberOfRowsInSection:section)
    self.steps.size
  end
  
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier('Cell')
    cell ||= UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:'Cell')
    
    cell.textLabel.text = steps[indexPath.row].type
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
    cell
  end
  
  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    # navigationController.pushViewController(CheckRunViewController.alloc.initWithCheckRun(steps[indexPath.row]), animated:true)
  end
end
