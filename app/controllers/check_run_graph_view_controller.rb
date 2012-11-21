class CheckRunGraphViewController < UIViewController
  attr_accessor :health_check
  attr_accessor :check_runs
  
  def initWithHealthCheck(health_check)
    self.health_check = health_check
    self.check_runs = []
    self.view.backgroundColor = UIColor.whiteColor
    init
  end
  
  def viewDidLoad
    self.title = "Check Runs Graph"
    
    load_data
    
    super
  end
  
  def load_data
    TinyMon.when_reachable do
      SVProgressHUD.showWithMaskType(SVProgressHUDMaskTypeClear)
      health_check.check_runs do |results|
        SVProgressHUD.dismiss
        if results
          self.check_runs = results
          view.addSubview(graph_view)
        else
          TinyMon.offline_alert
        end
      end
    end
  end
  
  def graph_view
    line_chart_view = PCLineChartView.alloc.initWithFrame([[0,0], [self.view.bounds.size.width,self.view.bounds.size.height]])
    line_chart_view.setAutoresizingMask(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight)
    
    component = PCLineChartViewComponent.alloc.init
    component.setTitle("sec")
    points = []
    x_labels = []
    check_runs.each_with_index do |check_run, i|
      x_labels << (i % 5 == 0 ? -i : "")
      points << check_run.duration
    end
    component.setPoints(points)
    component.setShouldLabelValues(false)
    component.setColour(UIColor.redColor)

    line_chart_view.setComponents([component])
    line_chart_view.setXLabels(x_labels.reverse)
    line_chart_view.minValue = 0
    line_chart_view.maxValue = points.max
    line_chart_view.interval = line_chart_view.maxValue / 5.0
    line_chart_view
  end
end
