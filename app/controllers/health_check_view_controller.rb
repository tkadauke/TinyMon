class HealthCheckViewController < Formotion::FormController
  attr_accessor :health_check
  
  def initWithHealthCheck(health_check, parent:parent)
    @new_record = false
    @parent = parent
    self.health_check = health_check
    initWithForm(build_form)
    self.title = health_check.name
    self
  end
  
  def initWithSite(site, parent:parent)
    @parent = parent
    @new_record = true
    self.health_check = HealthCheck.new
    self.health_check.site = site
    initWithForm(build_edit_form)
    self.title = "New Health Check"
    self
  end
  
  def viewDidLoad
    if User.current.can_edit_health_checks?
      show_edit_button unless @new_record
    end
    super
  end
  
  def edit
    self.form = build_edit_form
    self.form.controller = self
    tableView.reloadData
    self.title = health_check.name
    show_done_button
  end
  
  def done_editing
    self.health_check.update_attributes(form.render)
    TinyMon.when_reachable do
      SVProgressHUD.showWithMaskType(SVProgressHUDMaskTypeClear)
      if @new_record
        self.health_check.create do |result|
          SVProgressHUD.dismiss
          if result
            @parent.health_checks << result
            self.navigationController.popViewControllerAnimated(true)
          else
            TinyMon.offline_alert
          end
        end
      else
        self.health_check.save do |result|
          SVProgressHUD.dismiss
          if result
            self.form = build_form
            self.form.controller = self
            tableView.reloadData
            self.title = health_check.name
            show_edit_button
          else
            TinyMon.offline_alert
          end
        end
      end
    end
  end
  
  def show_edit_button
    @edit_button = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemEdit, target:self, action:'edit')
    self.navigationItem.rightBarButtonItem = @edit_button
  end
  
  def show_done_button
    @done_button = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemDone, target:self, action:'done_editing')
    self.navigationItem.rightBarButtonItem = @done_button
  end
  
  def delete
    actionSheet = UIActionSheet.alloc.initWithTitle("Really delete?",
                                                             delegate:self,
                                                    cancelButtonTitle:"No",
                                               destructiveButtonTitle:"Yes, delete",
                                                    otherButtonTitles:nil)
  
    actionSheet.showInView(UIApplication.sharedApplication.keyWindow)
  end
  
  def actionSheet(sender, clickedButtonAtIndex:index)
    if index == sender.destructiveButtonIndex
      TinyMon.when_reachable do
        SVProgressHUD.showWithMaskType(SVProgressHUDMaskTypeClear)
        self.health_check.destroy do |result|
          SVProgressHUD.dismiss
          if result
            @parent.health_checks.delete(self.health_check)
            self.navigationController.popViewControllerAnimated(true)
          else
            TinyMon.offline_alert
          end
        end
      end
    end
  end
  
private
  def build_form
    form = Formotion::Form.new({
      sections: [{
        rows: [{
          value: health_check.name,
          title: "Name",
          type: :label
        }, {
          value: health_check.site.name,
          title: "Site",
          type: :label
        }, {
          value: health_check.description,
          title: "Description",
          key: :description,
          type: health_check.description.blank? ? :label : :disclose
        }, {
          value: health_check.interval,
          title: "Check Interval",
          type: :label
        }, {
          value: health_check.enabled ? 'Yes' : 'No',
          title: "Active",
          type: :label
        }]
      }, {
        rows: [{
          value: Time.ago_in_words(health_check.last_checked_at_to_now),
          title: "Last Check",
          type: :disclose,
          key: :last_check
        }, {
          value: (Time.future_in_words(health_check.next_check_at_to_now) if health_check.enabled),
          title: "Next Check",
          type: :label
        }, {
          value: UIImage.imageNamed("#{health_check.status}.png"),
          title: "Status",
          type: :icon
        }, {
          value: UIImage.imageNamed("weather-#{health_check.weather}.png"),
          title: "Weather",
          type: :icon
        }]
      }, {
        rows: [{
          title: "Steps",
          key: :steps,
          type: :disclose
        }, {
          title: "Check runs",
          key: :check_runs,
          type: :disclose
        }, {
          title: "Graph",
          key: :graph,
          type: :disclose
        }]
      }]
    })
    
    form.on_select do |key|
      case key
      when :description
        navigationController.pushViewController(HtmlViewController.alloc.initWithHTML(health_check.description, title:"Description"), animated:true)
      when :last_check
        TinyMon.when_reachable do
          SVProgressHUD.showWithMaskType(SVProgressHUDMaskTypeClear)
          health_check.check_runs do |results|
            SVProgressHUD.dismiss
            if results
              navigationController.pushViewController(CheckRunViewController.alloc.initWithCheckRun(results.first), animated:true)
            else
              TinyMon.offline_alert
            end
          end
        end
      when :steps
        navigationController.pushViewController(StepsViewController.alloc.initWithHealthCheck(health_check), animated:true)
      when :check_runs
        navigationController.pushViewController(CheckRunsViewController.alloc.initWithHealthCheck(health_check), animated:true)
      when :graph
        navigationController.pushViewController(CheckRunGraphViewController.alloc.initWithHealthCheck(health_check), animated:true)
      end
    end
    form
  end

  def build_edit_form
    sections = [{
      rows: [{
        value: health_check.name,
        title: "Name",
        key: :name,
        type: :string
      }, {
        value: health_check.description,
        title: "Description",
        key: :description,
        type: :text,
        row_height: 100
      }, {
        value: health_check.interval.to_s,
        title: "Check Interval",
        key: :interval,
        type: :picker,
        items: ["1", "2", "3", "5", "10", "15", "20", "30", "60", "120", "180", "240", "360", "720", "1440"]
      }, {
        value: health_check.enabled,
        title: "Active",
        key: :enabled,
        type: :switch
      }]
    }, {
      rows: [{
        title: "Save",
        type: :submit
      }]
    }, ({
      rows: [{
        title: "Delete",
        type: :delete
      }]
    } if !@new_record && User.current.can_delete_health_checks?)].compact
    
    form = Formotion::Form.new({
      sections: sections
    })
    
    form.on_submit do
      done_editing
    end
    form.on_delete do
      delete
    end
    form
  end
end
