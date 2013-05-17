class HealthCheckViewController < Formotion::FormController
  attr_accessor :health_check
  
  def initWithHealthCheck(health_check, parent:parent)
    @parent = parent
    @health_check = health_check
    initWithForm(build_form)
    self.title = health_check.name
    self
  end
  
  def initWithSite(site, parent:parent)
    @parent = parent
    @health_check = HealthCheck.new
    @health_check.site = site
    initWithForm(build_edit_form)
    self.title = I18n.t("health_check_controller.new_title")
    self
  end
  
  def viewDidLoad
    if User.current.can_edit_health_checks?
      show_edit_button unless @health_check.new_record?
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
    @health_check.update_attributes(form.render)
    TinyMon.when_reachable do
      SVProgressHUD.showWithMaskType(SVProgressHUDMaskTypeClear)
      @health_check.save do |result, response|
        SVProgressHUD.dismiss
        if response.ok? && result
          if @health_check.new_record?
            @created = true
            if @parent
              @parent.health_checks << result
              self.navigationController.popViewControllerAnimated(true)
            end
          else
            self.form = build_form
            self.form.controller = self
            tableView.reloadData
            self.title = health_check.name
            show_edit_button
          end
        else
          TinyMon.offline_alert
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
    @action_sheet = UIActionSheet.alloc.initWithTitle(I18n.t("alert.really_delete"),
                                                             delegate:self,
                                                    cancelButtonTitle:I18n.t("alert.no_answer"),
                                               destructiveButtonTitle:I18n.t("alert.yes_answer"),
                                                    otherButtonTitles:nil)
  
    @action_sheet.showInView(UIApplication.sharedApplication.keyWindow)
  end
  
  def actionSheet(sender, clickedButtonAtIndex:index)
    if index == sender.destructiveButtonIndex
      TinyMon.when_reachable do
        SVProgressHUD.showWithMaskType(SVProgressHUDMaskTypeClear)
        @health_check.destroy do |result, response|
          SVProgressHUD.dismiss
          if response.ok? && result
            @deleted = true
            if @parent
              @parent.health_checks.delete(@health_check)
              self.navigationController.popViewControllerAnimated(true)
            end
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
          title: I18n.t("form.name"),
          type: :label
        }, {
          value: health_check.site.name,
          title: I18n.t("form.site"),
          type: :label
        }, {
          value: health_check.description,
          title: I18n.t("form.description"),
          key: :description,
          type: health_check.description.blank? ? :label : :disclose
        }, {
          value: health_check.interval,
          title: I18n.t("form.check_interval"),
          type: :label
        }, {
          value: health_check.enabled ? I18n.t("form.enabled_yes") : I18n.t("form.enabled_no"),
          title: I18n.t("form.active"),
          type: :label
        }]
      }, {
        rows: [{
          title: I18n.t("form.run"),
          type: :disclose,
          key: :run
        }]
      }, {
        rows: [{
          value: Time.ago_in_words(health_check.last_checked_at_to_now),
          title: I18n.t("form.last_check"),
          type: :disclose,
          key: :last_check
        }, {
          value: (Time.future_in_words(health_check.next_check_at_to_now) if health_check.enabled),
          title: I18n.t("form.next_check"),
          type: :label
        }, {
          value: UIImage.imageNamed("#{health_check.status}.png"),
          title: I18n.t("form.status"),
          type: :icon
        }, {
          value: UIImage.imageNamed("weather-#{health_check.weather}.png"),
          title: I18n.t("form.weather"),
          type: :icon
        }]
      }, {
        rows: [{
          title: I18n.t("form.steps"),
          key: :steps,
          type: :disclose
        }, {
          title: I18n.t("form.check_runs"),
          key: :check_runs,
          type: :disclose
        }, {
          title: I18n.t("form.graph"),
          key: :graph,
          type: :disclose
        }]
      }]
    })
    
    form.on_select do |key|
      case key
      when :description
        navigationController.pushViewController(HtmlViewController.alloc.initWithHTML(health_check.description, title:I18n.t("description_controller.title")), animated:true)
      when :run
        run
      when :last_check
        show_last_check
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
  
  def run
    TinyMon.when_reachable do
      SVProgressHUD.showWithMaskType(SVProgressHUDMaskTypeClear)
      @health_check.run do |result, response|
        SVProgressHUD.dismiss
        if response.ok? && result
          navigationController.pushViewController(CheckRunViewController.alloc.initWithCheckRun(result), animated:true)
        else
          TinyMon.offline_alert
        end
      end
    end
  end
  
  def show_last_check
    TinyMon.when_reachable do
      SVProgressHUD.showWithMaskType(SVProgressHUDMaskTypeClear)
      health_check.check_runs do |results, response|
        SVProgressHUD.dismiss
        if response.ok? && results
          navigationController.pushViewController(CheckRunViewController.alloc.initWithCheckRun(results.first), animated:true)
        else
          TinyMon.offline_alert
        end
      end
    end
  end

  def build_edit_form
    sections = [{
      rows: [{
        value: health_check.name,
        title: I18n.t("form.name"),
        key: :name,
        type: :string
      }, {
        value: health_check.description,
        title: I18n.t("form.description"),
        key: :description,
        type: :text,
        row_height: 100
      }, {
        value: health_check.interval.to_s,
        title: I18n.t("form.check_interval"),
        key: :interval,
        type: :picker,
        items: ["1", "2", "3", "5", "10", "15", "20", "30", "60", "120", "180", "240", "360", "720", "1440"]
      }, {
        value: health_check.enabled,
        title: I18n.t("form.active"),
        key: :enabled,
        type: :switch
      }]
    }, {
      rows: [{
        title: I18n.t("form.save"),
        type: :submit
      }]
    }, ({
      rows: [{
        title: I18n.t("form.delete"),
        type: :delete
      }]
    } if !@health_check.new_record? && User.current.can_delete_health_checks?)].compact
    
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
