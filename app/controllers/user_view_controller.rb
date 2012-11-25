class UserViewController < Formotion::FormController
  attr_accessor :user
  
  def initWithUser(user)
    self.user = user
    initWithForm(build_form)
    self.title = user.full_name
    self
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
      }]
    })
    
    form
  end
end
