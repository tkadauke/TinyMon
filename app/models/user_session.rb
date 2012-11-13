class UserSession < RemoteModule::RemoteModel
  attribute :email, :password
  
  collection_url "login"
  
  def login(&block)
    post(collection_url, :payload => { :user_session => attributes }, &block)
  end
end
