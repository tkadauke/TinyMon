class LoginViewController < Formotion::FormController
  def init
    initWithForm(build_form)
    self.title = "Login"
    @form.on_submit do |form|
      submit(form)
    end
    self
  end
  
  def submit(form)
    login_data = form.render
    server = login_data.delete(:server)
    RemoteModule::RemoteModel.root_url = "http://#{server}/"
    TinyMon.server = server.split(":").first

    TinyMon.when_reachable do
      session = UserSession.new(login_data)
      session.login do |response, json|
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
        rows: [{
          title: "Login",
          type: :submit,
        }]
      }]
    })
  end
end
