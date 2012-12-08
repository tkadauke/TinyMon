class CheckRunViewController < Formotion::FormController
  attr_accessor :check_run
  
  def initWithCheckRun(check_run)
    self.check_run = check_run
    initWithForm(build_form)
    self.title = "Check Run"
    self
  end
  
  def viewDidLoad
    set_timer
    super
  end
  
  def reload
    self.check_run.reload do |run, response|
      if response.ok? && run
        self.check_run = run
        set_timer
        self.form = build_form
        self.form.controller = self
        self.title = "Check Run"
        tableView.reloadData
      end
    end
  end
  
  def set_timer
    if check_run.status.blank?
      NSTimer.scheduledTimerWithTimeInterval(2, target:self, selector:'reload', userInfo:nil, repeats:false)
    end
  end
  
private
  def build_form
    form = Formotion::Form.new({
      sections: [{
        rows: [{
          value: check_run.health_check.name,
          title: "Health Check",
          type: :label
        }, {
          value: check_run.health_check.site.name,
          title: "Site",
          type: :label
        }]
      }, {
        rows: [{
          value: UIImage.imageNamed("#{check_run.status}.png"),
          title: "Status",
          type: check_run.status.present? ? :icon : :spinner
        }, {
          value: Time.ago_in_words(check_run.created_at_to_now),
          title: "When",
          type: :label
        }, {
          value: "#{"%2.1f" % check_run.duration.to_f} s",
          title: "Duration",
          type: :label
        }, ({
          value: check_run.error_message,
          title: "Message",
          key: :message,
          type: :disclose
        } if check_run.error_message.present?)].compact
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
