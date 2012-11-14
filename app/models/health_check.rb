class HealthCheck < RemoteModule::RemoteModel
  attribute :name, :enabled, :interval, :description
  attr_accessor :id, :permalink, :status, :site_id, :weather, :last_checked_at_to_now, :next_check_at_to_now
  
  collection_url "accounts/:account_id/sites/:site_permalink/health_checks"
  member_url "accounts/:account_id/sites/:site_permalink/health_checks/:permalink"
  
  custom_urls :upcoming_url => 'health_checks/upcoming'
  
  association :check_runs, lambda { |r| { :account_id => r.account_id, :site_permalink => r.site_permalink, :check_permalink => r.permalink } }
  association :steps, lambda { |r| { :account_id => r.account_id, :site_permalink => r.site_permalink, :check_permalink => r.permalink } }
  
  scope :upcoming

  belongs_to :site
  
  def account_id
    site && site.account_id
  end
  
  def site_permalink
    site && site.permalink
  end
  
  def status_icon
    if enabled
      status
    else
      "offline"
    end
  end
end
