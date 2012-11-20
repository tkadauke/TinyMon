class CheckRunViewController < Formotion::FormController
  attr_accessor :check_run
  
  def initWithCheckRun(check_run)
    self.check_run = check_run
    initWithForm(build_form)
    self.title = "Check Run"
    self
  end
  
private
  def build_form
    form = Formotion::Form.new({
      sections: [{
        rows: [{
          value: check_run.health_check.name,
          title: "Health Check",
          type: :static
        }, {
          value: check_run.health_check.site.name,
          title: "Site",
          type: :static
        }]
      }, {
        rows: [{
          value: UIImage.imageNamed("#{check_run.status}.png"),
          title: "Status",
          type: :icon
        }, {
          value: Time.ago_in_words(check_run.created_at_to_now),
          title: "When",
          type: :static
        }, {
          value: "#{"%2.1f" % check_run.duration} s",
          title: "Duration",
          type: :static
        }, {
          value: check_run.error_message,
          title: "Message",
          key: :message,
          type: :disclose
        }]
      }, {
        rows: [{
          title: "Log",
          key: :log,
          type: :disclose
        }]
      }]
    })
    
    form.on_select do |key|
      case key
      when :message
        navigationController.pushViewController(HtmlViewController.alloc.initWithHTML(check_run.error_message, title:"Message"), animated:true)
      when :log
        navigationController.pushViewController(CheckRunLogViewController.alloc.initWithCheckRun(check_run), animated:true)
      end
    end
    form
  end
end
