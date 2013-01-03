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
    fresh_cell.tap do |cell|
      check_run = check_runs[indexPath.row]
      cell.textLabel.text = check_run.health_check.name
      cell.detailTextLabel.text = check_run.health_check.site.name + ", " + Time.ago_in_words(check_run.created_at_to_now)
      cell.imageView.image = UIImage.imageNamed("#{check_run.status}.png")
    end
  end
  
  def load_data
    TinyMon.when_reachable do
      SVProgressHUD.showWithMaskType(SVProgressHUDMaskTypeClear)
      CheckRun.recent do |results, response|
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

private
  def fresh_cell
    tableView.dequeueReusableCellWithIdentifier('Cell') ||
    UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:'Cell').tap do |cell|
      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
    end
  end
end
