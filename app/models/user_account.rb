class UserAccount < RemoteModule::RemoteModel
  attr_accessor :id, :role, :account_id
  
  collection_url "accounts/:account_id/user_accounts"
  member_url "accounts/:account_id/user_accounts/:id"
  
  has_one :user
end
