class HealthCheck < RemoteModule::RemoteModel
  attribute :name, :enabled, :interval, :description
  attr_accessor :id, :permalink, :last_checked_at, :next_check_at, :status, :site_id, :weather
  
  collection_url "accounts/:account_id/sites/:site_permalink/health_checks"
  member_url "accounts/:account_id/sites/:site_permalink/health_checks/:permalink"
  
  attr_accessor :site
  
  def account_id
    site && site.account_id
  end
  
  def site_permalink
    site && site.permalink
  end
  
  def save(&block)
    put(member_url, :payload => { :health_check => attributes }, &block)
  end
  
  def create(&block)
    post(collection_url, :payload => { :health_check => attributes }) do |response, json|
      block.call HealthCheck.new(json)
    end
  end
  
  def destroy(&block)
    delete(member_url, &block)
  end
  
  def check_runs(&block)
    block.call(@check_runs) and return if @check_runs
    
    CheckRun.find_all(:account_id => account_id, :site_permalink => site_permalink, :check_permalink => permalink) do |results|
      results.each do |result|
        result.health_check = self
      end
      @check_runs = results
      block.call(results)
    end
  end
  
  def steps(&block)
    block.call(@steps) and return if @steps
    
    Step.find_all(:account_id => account_id, :site_permalink => site_permalink, :check_permalink => permalink) do |results|
      results.each do |result|
        result.health_check = self
      end
      @steps = results
      block.call(results)
    end
  end
  
  def reset_check_runs
    @check_runs = nil
  end
  
  def reset_steps
    @steps = nil
  end
end
