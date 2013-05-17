module RootController
  def viewDidLoad
    add_menu_button
    
    super
  end
  
  def add_menu_button
    @menu_button = UIBarButtonItem.alloc.initWithTitle(I18n.t("menu_button"), style:UIBarButtonItemStyleBordered, target:self.viewDeckController, action:'toggleLeftView')
    self.navigationItem.leftBarButtonItem = @menu_button
  end
end
