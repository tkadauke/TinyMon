class CurrentUserViewController < UserViewController
  include RootController
  
  def init
    initWithUser(User.current)
  end
end
