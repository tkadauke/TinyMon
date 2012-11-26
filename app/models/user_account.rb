class UserAccount < MotionResource::Base
  attr_accessor :id, :role, :account_id
  
  self.collection_url = "accounts/:account_id/user_accounts"
  self.member_url = "accounts/:account_id/user_accounts/:id"
  
  has_one :user
end
