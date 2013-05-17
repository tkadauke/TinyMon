class UserTableViewCell < UITableViewCell
  attr_reader :user_account
  
  def initWithStyle(style, reuseIdentifier:reuseIdentifier)
    super
    
    self.stylesheet = :user_cell_sheet
  
    layout self, :cell do
      @image = subview(HJManagedImageV, :image)
      @name_label = subview(UILabel, :name)
      @role_label = subview(UILabel, :role)
    end
    self
  end
  
  def user_account=(value)
    @image.clear if user_account != value
    @user_account = value
    
    @name_label.text = user_account.user.full_name
    @role_label.text = I18n.t("user.role.#{user_account.role}")
    
    @image.url = NSURL.URLWithString(user_account.user.gravatar_url)
    ImageManager.instance.manage(@image)
  end
end
