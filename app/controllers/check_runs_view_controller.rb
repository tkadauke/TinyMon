class CheckRunsViewController < UITableViewController
  include Refreshable
  
  attr_accessor :health_check
  attr_accessor :all_check_runs
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
    self.toolbarItems = toolbar_items
    
    load_data
    
    on_refresh do
      health_check.reset_check_runs
      load_data
    end
    
    super
  end
  
  def tableView(tableView, numberOfRowsInSection:section)
    self.check_runs.size
  end
  
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier('Cell')
    cell ||= UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:'Cell')
    
    check_run = check_runs[indexPath.row]
    cell.textLabel.text = Time.ago_in_words(check_run.created_at_to_now)
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
    cell.imageView.image = UIImage.imageNamed("#{check_run.status}.png")
    cell
  end
  
  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    navigationController.pushViewController(CheckRunViewController.alloc.initWithCheckRun(check_runs[indexPath.row]), animated:true)
  end
  
  def load_data
    TinyMon.when_reachable do
      SVProgressHUD.showWithMaskType(SVProgressHUDMaskTypeClear)
      health_check.check_runs do |results, response|
        SVProgressHUD.dismiss
        if response.ok? && results
          self.all_check_runs = results
          change_filter(@filter)
        else
          TinyMon.offline_alert
        end
        tableView.reloadData
        end_refreshing
      end
    end
  end

  def toolbar_items
    space = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemFlexibleSpace, target:nil, action:nil)
 
    [space, filter_button_item, space]
  end
  
  def filter_button_item
    @filter = UISegmentedControl.alloc.initWithItems(["All", "Success", "Failure"])
    @filter.segmentedControlStyle = UISegmentedControlStyleBar
    @filter.selectedSegmentIndex = 0
    @filter.addTarget(self, action:"change_filter:", forControlEvents:UIControlEventValueChanged)
 
    UIBarButtonItem.alloc.initWithCustomView(@filter)
  end

  def change_filter(sender)
    case sender.selectedSegmentIndex
    when 1
      self.check_runs = self.all_check_runs.select { |x| x.status == 'success' }
    when 2
      self.check_runs = self.all_check_runs.select { |x| x.status == 'failure' }
    else
      self.check_runs = self.all_check_runs
    end
    self.tableView.reloadSections(NSIndexSet.indexSetWithIndex(0), withRowAnimation:UITableViewRowAnimationFade)
  end
end
