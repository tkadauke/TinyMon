module LoadingController
  attr_accessor :loading
  
  def init
    self.loading = true
    super
  end
  
  def done_loading
    self.loading = false
    tableView.reloadData
  end
  
  def loading_cell
    LoadingCell.loadingCellWithTableView(self.tableView)
  end
end
