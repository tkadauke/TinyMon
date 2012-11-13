class StepsViewController < UITableViewController
  include Refreshable
  
  attr_accessor :health_check
  attr_accessor :steps
  
  def initWithHealthCheck(health_check)
    self.health_check = health_check
    self.steps = []
    init
  end
  
  def viewDidLoad
    self.title = "Steps"
    
    load_data
    
    on_refresh do
      health_check.reset_steps
      load_data
    end
    
    super
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
  
  def load_data
    health_check.steps do |results|
      self.steps = results
      tableView.reloadData
      end_refreshing
    end
  end
end
