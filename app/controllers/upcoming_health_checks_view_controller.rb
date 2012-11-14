class UpcomingHealthChecksViewController < HealthChecksViewController
  include ActivityTabs
  include RootController
  
  def init
    self.navigationItem.titleView = activity_tabs(1)
    super
  end
  
  def viewDidLoad
    super
    
    # Remove plus button from base class
    self.navigationItem.rightBarButtonItem = nil
    
    load_data
    
    on_refresh do
      load_data
    end
  end
  
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier('Cell')
    cell ||= UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:'Cell')
    
    health_check = health_checks[indexPath.row]
    cell.textLabel.text = health_check.name
    cell.detailTextLabel.text = health_check.next_check_at.future_in_words
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
    cell.imageView.image = UIImage.imageNamed("#{health_check.status_icon}.png")
    cell
  end
  
  def load_data
    TinyMon.when_reachable do
      HealthCheck.upcoming do |results|
        if results
          self.health_checks = results
          tableView.reloadData
        else
          TinyMon.offline_alert
        end
        end_refreshing
      end
    end
  end
end
