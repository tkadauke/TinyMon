class User < RemoteModule::RemoteModel
  attr_accessor :role, :full_name, :current_account_id, :email
end
