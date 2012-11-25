class Site < RemoteModule::RemoteModel
  attribute :url, :name
  attr_accessor :account_id, :permalink, :status
  
  self.collection_url = "sites"
  self.member_url = "accounts/:account_id/sites/:permalink"
  
  has_many :health_checks, lambda { |r| { :account_id => r.account_id, :site_permalink => r.permalink } }
end
