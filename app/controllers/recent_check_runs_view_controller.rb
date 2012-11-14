class RecentCheckRunsViewController < CheckRunsViewController
  include ActivityTabs
  include RootController
  
  def init
    self.navigationItem.titleView = activity_tabs(0)
    super
  end
  
  def viewDidLoad
    super
    
    on_refresh do
      load_data
    end
  end
  
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier('Cell')
    cell ||= UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:'Cell')
    
    check_run = check_runs[indexPath.row]
    cell.textLabel.text = check_run.health_check.name
    cell.detailTextLabel.text = check_run.health_check.site.name + " " + Time.ago_in_words(check_run.created_at_to_now)
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
    cell.imageView.image = UIImage.imageNamed(check_run.status)
    cell
  end
  
  def load_data
    TinyMon.when_reachable do
      CheckRun.recent do |results|
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
