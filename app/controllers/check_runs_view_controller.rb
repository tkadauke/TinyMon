class CheckRunsViewController < UITableViewController
  include Refreshable
  
  attr_accessor :health_check
  attr_accessor :check_runs
  
  def init
    self.check_runs = []
    super
  end
  
  def initWithHealthCheck(health_check)
    self.health_check = health_check
    init
  end
  
  def viewDidLoad
    self.title = "Check Runs"
    
    load_data
    
    on_refresh do
      health_check.reset_check_runs
      load_data
    end
    
    super
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
    
    check_run = check_runs[indexPath.row]
    cell.textLabel.text = check_run.created_at.ago_in_words
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
    cell.imageView.image = UIImage.imageNamed(check_run.status)
    cell
  end
  
  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    navigationController.pushViewController(CheckRunViewController.alloc.initWithCheckRun(check_runs[indexPath.row]), animated:true)
  end
  
  def load_data
    TinyMon.when_reachable do
      health_check.check_runs do |results|
        if results
          self.check_runs = results
          tableView.reloadData
        else
          TinyMon.offline_alert
        end
        end_refreshing
      end
    end
  end
end
