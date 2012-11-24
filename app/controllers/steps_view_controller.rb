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
    
    step = steps[indexPath.row]
    cell.textLabel.text = step.summary
    cell.detailTextLabel.text = step.detail
    cell
  end
  
  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    # navigationController.pushViewController(CheckRunViewController.alloc.initWithCheckRun(steps[indexPath.row]), animated:true)
  end
  
  def load_data
    TinyMon.when_reachable do
      SVProgressHUD.showWithMaskType(SVProgressHUDMaskTypeClear)
      health_check.steps do |results|
        SVProgressHUD.dismiss
        if results
          self.steps = results
        else
          TinyMon.offline_alert
        end
        tableView.reloadData
        end_refreshing
      end
    end
  end
end
