class LoadingCell < UITableViewCell
  CELL_FRAME = [[0,0], [320, 44]]
  LABEL_FRAME = [[120, 11], [79, 21]]
  ACTIVITY_INDICATOR_FRAME = [[92,11],[20,20]]

  LABEL_TEXT = 'Loading...'

  def self.loadingCellWithTableView(tableView)
    tableView.dequeueReusableCellWithIdentifier(self.class.to_s) || begin
      alloc.initWithFrame(CELL_FRAME)
    end
  end

  def reuseIdentifier
    self.class.to_s
  end

  def initWithFrame(frame)
    super(frame)
    addSubview(activityIndicator)
    addSubview(label)
  end

  def label
    @label ||= begin
      _label           = UILabel.alloc.initWithFrame(LABEL_FRAME)
      _label.text      = LABEL_TEXT
      _label.textColor = UIColor.darkGrayColor
      _label.backgroundColor = UIColor.clearColor
      _label
    end
  end

  def activityIndicator
    @activityIndicator ||= begin
      _activityIndicator = UIActivityIndicatorView.alloc.initWithActivityIndicatorStyle(UIActivityIndicatorViewStyleGray)
      _activityIndicator.frame = ACTIVITY_INDICATOR_FRAME
      _activityIndicator.startAnimating
      _activityIndicator
    end
  end
end
