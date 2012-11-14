class CheckRun < RemoteModule::RemoteModel
  attr_accessor :health_check_id, :deployment_id, :log, :account_id, :id, :error_message, :user_id, :status, :duration
  date_field :created_at, :ended_at, :started_at
  
  collection_url "accounts/:account_id/sites/:site_permalink/health_checks/:check_permalink/check_runs"
  
  custom_urls :recent_url => "check_runs/recent"
  
  belongs_to :health_check
  
  scope :recent
  
  def site_permalink
    health_check && health_check.site && health_check.site.permalink
  end
  
  def check_permalink
    health_check && health_check.permalink
  end
end
