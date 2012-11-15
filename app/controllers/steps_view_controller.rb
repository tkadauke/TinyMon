class StepsViewController < UITableViewController
  include Refreshable
  include LoadingController
  
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
    if loading
      1
    else
      self.steps.size
    end
  end
  
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    if loading
      loading_cell
    else
      cell = tableView.dequeueReusableCellWithIdentifier('Cell')
      cell ||= UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:'Cell')
    
      cell.textLabel.text = steps[indexPath.row].type
      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
      cell
    end
  end
  
  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    return if loading
    # navigationController.pushViewController(CheckRunViewController.alloc.initWithCheckRun(steps[indexPath.row]), animated:true)
  end
  
  def load_data
    TinyMon.when_reachable do
      health_check.steps do |results|
        if results
          self.steps = results
        else
          TinyMon.offline_alert
        end
        done_loading
        end_refreshing
      end
    end
  end
end
