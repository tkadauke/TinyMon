class StepViewController < Formotion::FormableController
  attr_accessor :step
  
  def initWithStep(step, parent:parent)
    @new_record = false
    @parent = parent
    self.step = step
    initWithModel(step)
    self.title = step.summary
    
    self.form.create_section(
      rows: [{
        title: "Save",
        type: :submit
      }]
    )
    
    self.form.on_submit do
      done_editing
    end
    
    self
  end
  
  def done_editing
    TinyMon.when_reachable do
      SVProgressHUD.showWithMaskType(SVProgressHUDMaskTypeClear)
      if @new_record
        self.step.create do |result|
          SVProgressHUD.dismiss
          if result
            @parent.steps << result
            self.navigationController.popViewControllerAnimated(true)
          else
            TinyMon.offline_alert
          end
        end
      else
        self.step.save do |result|
          SVProgressHUD.dismiss
          if result
            self.navigationController.popViewControllerAnimated(true)
          else
            TinyMon.offline_alert
          end
        end
      end
    end
  end
end
