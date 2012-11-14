class HealthCheck < RemoteModule::RemoteModel
  attribute :name, :enabled, :interval, :description
  attr_accessor :id, :permalink, :last_checked_at, :next_check_at, :status, :site_id, :weather
  
  collection_url "accounts/:account_id/sites/:site_permalink/health_checks"
  member_url "accounts/:account_id/sites/:site_permalink/health_checks/:permalink"
  
  custom_urls :upcoming_url => 'health_checks/upcoming'
  
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
  
  def save(&block)
    put(member_url, :payload => { :health_check => attributes }) do |response, json|
      block.call json ? HealthCheck.new(json) : nil
    end
  end
  
  def create(&block)
    post(collection_url, :payload => { :health_check => attributes }) do |response, json|
      block.call json ? HealthCheck.new(json) : nil
    end
  end
  
  def destroy(&block)
    delete(member_url) do |response, json|
      block.call json ? HealthCheck.new(json) : nil
    end
  end
  
  def check_runs(&block)
    block.call(@check_runs) and return if @check_runs
    
    CheckRun.find_all(:account_id => account_id, :site_permalink => site_permalink, :check_permalink => permalink) do |results|
      if results
        results.each do |result|
          result.health_check = self
        end
      end
      @check_runs = results
      block.call(results)
    end
  end
  
  def steps(&block)
    block.call(@steps) and return if @steps
    
    Step.find_all(:account_id => account_id, :site_permalink => site_permalink, :check_permalink => permalink) do |results|
      if results
        results.each do |result|
          result.health_check = self
        end
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
  
  def self.upcoming(&block)
    get(upcoming_url) do |response, json|
      if response.ok?
        objs = []
        arr_rep = nil
        if json.class == Array
          arr_rep = json
        elsif json.class == Hash
          plural_sym = self.pluralize.to_sym
          if json.has_key? plural_sym
            arr_rep = json[plural_sym]
          end
        else
          # the returned data was something else
          # ie a string, number
          request_block_call(block, nil, response)
          return
        end
        arr_rep.each { |one_obj_hash|
          objs << self.new(one_obj_hash)
        }
        request_block_call(block, objs, response)
      else
        request_block_call(block, nil, response)
      end
    end
  end
end
