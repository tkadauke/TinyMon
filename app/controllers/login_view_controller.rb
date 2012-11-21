class LoginViewController < Formotion::FormController
  cattr_accessor :first_login
  self.first_login = true
  
  def init
    initWithForm(build_form)
    self.title = "TinyMon - Login"
    @form.on_submit do |form|
      submit(form)
    end
    self
  end
  
  def viewDidLoad
    super
    return unless self.class.first_login
    
    login_data = @form.render
    if login_data[:server].present? && login_data[:email].present? && login_data[:password].present? && login_data[:auto_login]
      submit(@form)
      self.class.first_login = false
    end
  end
  
  def submit(form)
    login_data = form.render
    server = login_data.delete(:server)
    RemoteModule::RemoteModel.root_url = "http://#{server}/"
    TinyMon.server = server.split(":").first

    TinyMon.when_reachable do
      SVProgressHUD.showWithMaskType(SVProgressHUDMaskTypeClear)
      session = UserSession.new(login_data)
      session.login do |response, json|
        SVProgressHUD.dismiss
        if response.error_message
          UIAlertView.alert("Login failed", response.error_message)
        else
          if json
            Account.current_account_id = json["attempted_record"]["current_account_id"]
            UIApplication.sharedApplication.delegate.window.rootViewController = LoggedInViewDeckController.alloc.init
          else
            UIAlertView.alert("Login failed", "Wrong username or password")
          end
        end
      end
    end
  end

private
  def build_form
    @form ||= Formotion::Form.persist({
      persist_as: :credentials,
      sections: [{
        rows: [{
          title: "Email",
          key: :email,
          placeholder: "me@mail.com",
          type: :email,
          auto_correction: :no,
          auto_capitalization: :none
        }, {
          title: "Password",
          key: :password,
          placeholder: "required",
          type: :string,
          secure: true
        }]
      }, {
        title: "Server",
        rows: [{
          title: "Host name",
          value: "mon.tinymon.org",
          key: :server,
          type: :string,
          auto_correction: :no,
          auto_capitalization: :none
        }]
      }, {
        title: "Settings",
        rows: [{
          title: "Auto log in",
          key: :auto_login,
          type: :switch
        }]
      }, {
        rows: [{
          title: "Login",
          type: :submit
        }]
      }]
    })
  end
end
