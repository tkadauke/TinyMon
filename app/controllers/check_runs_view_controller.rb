class CheckRunsViewController < UITableViewController
  include Refreshable
  include LoadingController
  
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
  
  def numberOfSectionsInTableView(tableView)
    1
  end
  
  def tableView(tableView, numberOfRowsInSection:section)
    if loading
      1
    else
      self.check_runs.size
    end
  end
  
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    if loading
      loading_cell
    else
      cell = tableView.dequeueReusableCellWithIdentifier('Cell')
      cell ||= UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:'Cell')
    
      check_run = check_runs[indexPath.row]
      cell.textLabel.text = Time.ago_in_words(check_run.created_at_to_now)
      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
      cell.imageView.image = UIImage.imageNamed(check_run.status)
      cell
    end
  end
  
  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    return if loading
    navigationController.pushViewController(CheckRunViewController.alloc.initWithCheckRun(check_runs[indexPath.row]), animated:true)
  end
  
  def load_data
    TinyMon.when_reachable do
      health_check.check_runs do |results|
        if results
          self.all_check_runs = results
          change_filter(@filter)
        else
          TinyMon.offline_alert
        end
        done_loading
        end_refreshing
      end
    end
  end

  def toolbar_items
    space = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemFlexibleSpace, target:nil, action:nil)
 
    @filter = UISegmentedControl.alloc.initWithItems(["All", "Success", "Failure"])
    @filter.segmentedControlStyle = UISegmentedControlStyleBar
    @filter.selectedSegmentIndex = 0
    @filter.addTarget(self, action:"change_filter:", forControlEvents:UIControlEventValueChanged)
 
    filter_button_item = UIBarButtonItem.alloc.initWithCustomView(@filter)
    
    [space, filter_button_item, space]
  end

  def change_filter(sender)
    case sender.selectedSegmentIndex
    when 0
      self.check_runs = self.all_check_runs
    when 1
      self.check_runs = self.all_check_runs.select { |x| x.status == 'success' }
    when 2
      self.check_runs = self.all_check_runs.select { |x| x.status == 'failure' }
    end
    self.tableView.reloadSections(NSIndexSet.indexSetWithIndex(0), withRowAnimation:UITableViewRowAnimationFade)
  end
end
