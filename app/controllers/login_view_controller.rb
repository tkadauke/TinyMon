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
    session = UserSession.new(form.render)
    session.login do |response, json|
      cookies = response.headers['Set-Cookie'].split(/,\s*/)
      cookie_hash = cookies.inject({}) do |hash, cookie|
        name, content = *cookie.split(/;\s*/).first.split(/=/)
        hash[name] = content
        hash
      end
      RemoteModule::RemoteModel.default_url_options = {
        :headers => {
          "Cookie" => cookie_hash.map { |key, value| "#{key}=#{value}" }.join(";")
        }
      }
      self.navigationController.pushViewController SitesViewController.alloc.init, animated:true
    end
  end

private
  def build_form
    @form ||= Formotion::Form.new({
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
        }, {
          title: "Remember?",
          key: :remember,
          type: :switch,
        }]
      }, {
        title: "Server",
        key: :account_type,
        select_one: true,
        rows: [{
          title: "Host name",
          value: "mon.tinymon.org",
          key: :server,
          type: :string,
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
