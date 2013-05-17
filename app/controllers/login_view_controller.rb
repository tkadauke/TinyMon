class LoginViewController < Formotion::FormController
  cattr_accessor :first_login
  self.first_login = true
  
  def init
    initWithForm(build_form)
    self.title = I18n.t("login_controller.title")
    @form.on_submit do |form|
      submit(form)
    end
    self
  end
  
  def viewDidLoad
    super
    return unless self.class.first_login
    
    if valid?
      submit(@form)
      self.class.first_login = false
    end
  end
  
  def submit(form)
    login_data = form.render
    server = login_data.delete(:server)
    MotionResource::Base.root_url = "http://#{server}/en/"
    TinyMon.server = server.split(":").first

    TinyMon.when_reachable do
      SVProgressHUD.showWithMaskType(SVProgressHUDMaskTypeClear)
      session = UserSession.new(login_data)
      session.login do |response, json|
        SVProgressHUD.dismiss
        if response.error_message
          UIAlertView.alert(I18n.t("login_controller.alert.title"), response.error_message)
        else
          if json.present?
            User.current = User.new(json["attempted_record"])
            Account.find(User.current.current_account_id) do |account, response|
              if response.ok? && account
                Account.current = account
                UIApplication.sharedApplication.delegate.window.rootViewController = LoggedInViewDeckController.alloc.init
              else
                UIAlertView.alert(I18n.t("login_controller.alert.title"), I18n.t("login_controller.alert.text"))
              end
            end
          else
            UIAlertView.alert(I18n.t("login_controller.alert.title"), I18n.t("login_controller.alert.text"))
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
          title: I18n.t("form.email"),
          key: :email,
          placeholder: I18n.t("form.placeholder.email"),
          type: :email,
          auto_correction: :no,
          auto_capitalization: :none
        }, {
          title: I18n.t("form.password"),
          key: :password,
          placeholder: I18n.t("form.placeholder.required"),
          type: :string,
          secure: true
        }]
      }, {
        title: I18n.t("form.server"),
        rows: [{
          title: I18n.t("form.hostname"),
          value: I18n.t("form.placeholder.hostname"),
          key: :server,
          type: :string,
          auto_correction: :no,
          auto_capitalization: :none
        }]
      }, {
        title: I18n.t("form.settings"),
        rows: [{
          title: I18n.t("form.auto_login"),
          key: :auto_login,
          type: :switch
        }]
      }, {
        rows: [{
          title: I18n.t("form.login"),
          type: :submit
        }]
      }]
    })
  end
  
  def valid?
    login_data = @form.render
    login_data[:server].present? && login_data[:email].present? && login_data[:password].present? && login_data[:auto_login]
  end
end
