class CheckRun < MotionResource::Base
  attr_accessor :health_check_id, :deployment_id, :log, :error_message, :status, :duration, :created_at_to_now
  attribute :user_id
  
  self.collection_url = "accounts/:account_id/sites/:site_permalink/health_checks/:check_permalink/check_runs"
  self.member_url = "accounts/:account_id/sites/:site_permalink/health_checks/:check_permalink/check_runs/:id"
  
  belongs_to :health_check
  
  scope :recent, :url => "check_runs/recent"
  
  def site_permalink
    health_check && health_check.site && health_check.site.permalink
  end
  
  def check_permalink
    health_check && health_check.permalink
  end
  
  def account_id
    health_check && health_check.account_id
  end
end
