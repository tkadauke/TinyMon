class CheckRunLogEntryViewController < HtmlViewController
  attr_accessor :check_run
  attr_accessor :current_index
  
  def initWithCheckRun(check_run, index:index)
    self.check_run = check_run
    self.current_index = index
    refresh_title
    initWithHTML(check_run.log[index].last)
  end
  
  def viewDidLoad
    super
    
    self.navigationItem.rightBarButtonItem = up_down_button_item
  end

  def up_down(sender)
    if sender.selectedSegmentIndex == 0
      self.current_index -= 1
      self.current_index = 0 if self.current_index < 0
    else
      self.current_index += 1
      self.current_index = check_run.log.size - 1 if self.current_index >= check_run.log.size
    end
    
    self.html = check_run.log[self.current_index].last
    refresh_title
    reload_content
  end

private
  def refresh_title
    self.title = "Log Entry #{current_index + 1} of #{check_run.log.size}"
  end
  
  def up_down_button_item
    up_down = UISegmentedControl.alloc.initWithItems([" ▲ ", " ▼ "])
    up_down.segmentedControlStyle = UISegmentedControlStyleBar
    up_down.momentary = true
    up_down.addTarget(self, action:"up_down:", forControlEvents:UIControlEventValueChanged)
    
    UIBarButtonItem.alloc.initWithCustomView(up_down)
  end
end
