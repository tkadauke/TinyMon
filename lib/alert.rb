class UIAlertView
  def self.alert(title, text)
    alert = UIAlertView.alloc.initWithTitle(title, message:text,
                                      delegate:nil, cancelButtonTitle:"Ok", otherButtonTitles:nil)
    alert.show
  end
end
