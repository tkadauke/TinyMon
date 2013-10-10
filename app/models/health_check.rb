class HealthCheck < MotionResource::Base
  attribute :name, :enabled, :interval, :description
  attr_accessor :permalink, :status, :site_id, :weather, :last_checked_at_to_now, :next_check_at_to_now
  
  self.collection_url = "accounts/:account_id/sites/:site_permalink/health_checks"
  self.member_url = "accounts/:account_id/sites/:site_permalink/health_checks/:permalink"
  
  has_many :check_runs, :params => lambda { |r| { :account_id => r.account_id, :site_permalink => r.site_permalink, :check_permalink => r.permalink } }
  has_many :steps, :params => lambda { |r| { :account_id => r.account_id, :site_permalink => r.site_permalink, :check_permalink => r.permalink } }
  
  scope :all, :url => 'health_checks'
  scope :upcoming, :url => 'health_checks/upcoming'

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
  
  def run(&block)
    @check_run = CheckRun.new(:user_id => User.current.id)
    @check_run.health_check = self
    @check_run.create(&block)
  end
end
