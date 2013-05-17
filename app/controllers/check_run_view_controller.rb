class CheckRunViewController < Formotion::FormController
  attr_accessor :check_run
  
  def initWithCheckRun(check_run)
    @check_run = check_run
    initWithForm(build_form)
    self.title = I18n.t("check_run_controller.title")
    self
  end
  
  def viewDidLoad
    set_timer
    super
  end
  
  def reload
    @check_run.reload do |run, response|
      if response.ok? && run
        @check_run = run
        set_timer
        self.form = build_form
        self.form.controller = self
        self.title = I18n.t("check_run_controller.title")
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
          title: I18n.t("form.health_check"),
          type: :label
        }, {
          value: check_run.health_check.site.name,
          title: I18n.t("form.site"),
          type: :label
        }]
      }, {
        rows: [{
          value: UIImage.imageNamed("#{check_run.status}.png"),
          title: I18n.t("form.status"),
          type: check_run.status.present? ? :icon : :spinner
        }, {
          value: Time.ago_in_words(check_run.created_at_to_now),
          title: I18n.t("form.when"),
          type: :label
        }, {
          value: "#{"%2.1f" % check_run.duration.to_f} s",
          title: I18n.t("form.duration"),
          type: :label
        }, ({
          value: check_run.error_message,
          title: I18n.t("form.message"),
          key: :message,
          type: :disclose
        } if check_run.error_message.present?)].compact
      }, {
        rows: [{
          title: I18n.t("form.log"),
          key: :log,
          type: :disclose
        }]
      }]
    })
    
    form.on_select do |key|
      case key
      when :message
        navigationController.pushViewController(HtmlViewController.alloc.initWithHTML(check_run.error_message, title:I18n.t("message_controller.title")), animated:true)
      when :log
        navigationController.pushViewController(CheckRunLogViewController.alloc.initWithCheckRun(check_run), animated:true)
      end
    end
    form
  end
end
