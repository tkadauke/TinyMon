class StepViewController < Formotion::FormableController
  attr_accessor :step
  
  def initWithStep(step, parent:parent)
    @parent = parent
    self.step = step
    initWithModel(step)
    self.title = step.summary
    
    if User.current.can_edit_health_checks?
      self.form.create_section(
        rows: [{
          title: "Save",
          type: :submit
        }]
      )
    
      self.form.on_submit do
        done_editing
      end

      unless step.new_record?
        self.form.create_section(
          rows: [{
            title: "Delete",
            type: :delete
          }]
        )
    
        self.form.on_delete do
          delete
        end
      end
    end
    
    self
  end
  
  def done_editing
    TinyMon.when_reachable do
      SVProgressHUD.showWithMaskType(SVProgressHUDMaskTypeClear)
      self.step.save do |result, response|
        SVProgressHUD.dismiss
        if response.ok? && result
          if step.new_record?
            @created = true
            @parent.steps << result if @parent
            target = self.navigationController.viewControllers[-3]
            self.navigationController.popToViewController(target, animated:true)
          else
            self.navigationController.popViewControllerAnimated(true)
          end
        else
          TinyMon.offline_alert
        end
      end
    end
  end

  def delete
    @action_sheet = UIActionSheet.alloc.initWithTitle("Really delete?",
                                                             delegate:self,
                                                    cancelButtonTitle:"No",
                                               destructiveButtonTitle:"Yes, delete",
                                                    otherButtonTitles:nil)
  
    @action_sheet.showInView(UIApplication.sharedApplication.keyWindow)
  end
  
  def actionSheet(sender, clickedButtonAtIndex:index)
    if index == sender.destructiveButtonIndex
      TinyMon.when_reachable do
        SVProgressHUD.showWithMaskType(SVProgressHUDMaskTypeClear)
        self.step.destroy do |result, response|
          SVProgressHUD.dismiss
          if response.ok? && result
            @deleted = true
            @parent.steps.delete(self.step) if @parent
            self.navigationController.popViewControllerAnimated(true)
          else
            TinyMon.offline_alert
          end
        end
      end
    end
  end
end
