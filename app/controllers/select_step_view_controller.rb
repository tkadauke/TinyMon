class SelectStepViewController < UITableViewController
  def initWithHealthCheck(health_check, parent:parent)
    @health_check = health_check
    @parent = parent
    
    self.title = "Add Step"
    
    self
  end
  
  def tableView(tableView, numberOfRowsInSection:section)
    self.class.steps.size
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    fresh_cell.tap do |cell|
      cell.textLabel.text = self.class.steps[indexPath.row].first
    end
  end
  
  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    klass = Object.const_get(self.class.steps[indexPath.row].last)
    navigationController.pushViewController(StepViewController.alloc.initWithStep(klass.new(:health_check => @health_check), parent:@parent), animated:true)
    tableView.deselectRowAtIndexPath(indexPath, animated:true)
  end
  
  def self.steps
    @steps ||= Step.descendants.collect { |klass| [klass.summary, klass.name] }
  end
  
private
  def fresh_cell
    tableView.dequeueReusableCellWithIdentifier('Cell') ||
    UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:'Cell').tap do |cell|
      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
    end
  end
end
