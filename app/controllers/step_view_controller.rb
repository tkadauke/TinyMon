class StepViewController < Formotion::FormableController
  attr_accessor :step
  
  def initWithStep(step, parent:parent)
    @parent = parent
    @step = step
    initWithModel(step)
    self.title = step.class.summary
    
    if User.current.can_edit_health_checks?
      self.form.create_section(
        rows: [{
          title: I18n.t("form.save"),
          type: :submit
        }]
      )
    
      self.form.on_submit do
        done_editing
      end

      unless step.new_record?
        self.form.create_section(
          rows: [{
            title: I18n.t("form.delete"),
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
      @step.save do |result, response|
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
        @step.destroy do |result, response|
          SVProgressHUD.dismiss
          if response.ok? && result
            @deleted = true
            @parent.steps.delete(@step) if @parent
            self.navigationController.popViewControllerAnimated(true)
          else
            TinyMon.offline_alert
          end
        end
      end
    end
  end
end
