class Site < RemoteModule::RemoteModel
  attribute :url, :name
  attr_accessor :account_id, :permalink, :status
  
  collection_url "sites"
  member_url "accounts/:account_id/sites/:permalink"
  
  association :health_checks, lambda { |r| { :account_id => r.account_id, :site_permalink => r.permalink } }
end
