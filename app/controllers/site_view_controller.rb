class SiteViewController < Formotion::FormController
  attr_accessor :site
  
  def initWithSite(site, parent:parent)
    @new_record = false
    @parent = parent
    self.site = site
    initWithForm(build_form)
    self.title = site.name
    self
  end
  
  def initWithParent(parent)
    @new_record = true
    @parent = parent
    self.site = Site.new
    initWithForm(build_edit_form)
    self.title = "New Site"
    self
  end
  
  def viewDidLoad
    if User.current.can_edit_sites?
      show_edit_button unless @new_record
    end
    super
  end
  
  def edit
    self.form = build_edit_form
    self.form.controller = self
    tableView.reloadData
    self.title = site.name
    show_done_button
  end
  
  def done_editing
    self.site.update_attributes(form.render)
    TinyMon.when_reachable do
      SVProgressHUD.showWithMaskType(SVProgressHUDMaskTypeClear)
      if @new_record
        self.site.create do |result|
          SVProgressHUD.dismiss
          if result
            @parent.sites << result
            self.navigationController.popViewControllerAnimated(true)
          else
            TinyMon.offline_alert
          end
        end
      else
        self.site.save do |result|
          SVProgressHUD.dismiss
          if result
            self.form = build_form
            self.form.controller = self
            tableView.reloadData
            self.title = site.name
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
        self.site.destroy do |result|
          SVProgressHUD.dismiss
          if result
            @parent.sites.delete(self.site)
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
          value: site.name,
          title: "Name",
          type: :label
        }, {
          value: site.url,
          title: "Base URL",
          type: :disclose,
          key: :url
        }, {
          value: UIImage.imageNamed("#{site.status}.png"),
          title: "Status",
          type: :icon,
        }]
      }, {
        rows: [{
          title: "Health Checks",
          type: :disclose,
          key: :checks
        }]
      }]
    })
    
    form.on_select do |key|
      case key
      when :url
        UIApplication.sharedApplication.openURL(NSURL.URLWithString(site.url))
      when :checks
        navigationController.pushViewController(HealthChecksViewController.alloc.initWithSite(site), animated:true)
      end
    end
    form
  end

  def build_edit_form
    sections = [{
      rows: [{
        value: site.name,
        title: "Name",
        key: :name,
        type: :string
      }, {
        value: site.url,
        title: "Base URL",
        key: :url,
        type: :string,
        auto_correction: :no,
        auto_capitalization: :none
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
    } if !@new_record && User.current.can_delete_sites?)]
    
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
