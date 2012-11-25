class UserViewController < Formotion::FormController
  attr_accessor :user
  
  def initWithUser(user)
    self.user = user
    initWithForm(build_form)
    self.title = user.full_name
    self
  end
  
  def viewDidLoad
    TinyMon.when_reachable do
      SVProgressHUD.showWithMaskType(SVProgressHUDMaskTypeClear)
      self.user.reload do |result|
        SVProgressHUD.dismiss
        if result
          self.user = result
          self.form = build_form
          self.form.controller = self
          self.title = result.full_name
        else
          TinyMon.offline_alert
        end
      end
    end
  
    super
  end
  
private
  def build_form
    form = Formotion::Form.new({
      sections: [{
        rows: [{
          value: user.full_name,
          title: "Name",
          type: :label
        }, {
          value: user.email,
          title: "Email",
          type: :label
        }]
      }, {
        title: "Accounts",
        rows: user.accounts.map { |account| {
          title: account.name.to_s,
          type: :label
        } }
      }]
    })
    
    form
  end
end
