class SelectStepViewController < UITableViewController
  STEPS = [
    ["Check content", "CheckContentStep"],
    ["Check current URL", "CheckCurrentUrlStep"],
    ["Check E-Mail", "CheckEmailStep"],
    ["Choose radio button", "ChooseRadioButtonStep"],
    ["Click button", "ClickButtonStep"],
    ["Click email link", "ClickEmailLinkStep"],
    ["Click link", "ClickLinkStep"],
    ["Deselect check box", "DeselectCheckBoxStep"],
    ["Fill in", "FillInStep"],
    ["Select check box", "SelectCheckBoxStep"],
    ["Submit form", "SubmitFormStep"],
    ["Visit", "VisitStep"],
    ["Wait", "WaitStep"]
  ]
  
  def initWithHealthCheck(health_check, parent:parent)
    @health_check = health_check
    @parent = parent
    
    self.title = "Add Step"
    
    self
  end
  
  def numberOfSectionsInTableView(tableView)
    1
  end

  def tableView(tableView, numberOfRowsInSection:section)
    STEPS.size
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier('Cell')
    cell ||= UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:'Cell')

    cell.textLabel.text = STEPS[indexPath.row].first
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
    cell
  end
  
  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    klass = Object.const_get(STEPS[indexPath.row].last)
    navigationController.pushViewController(StepViewController.alloc.initWithStep(klass.new(:health_check => @health_check), parent:@parent, newRecord:true), animated:true)
  end
end
