class Site < RemoteModule::RemoteModel
  attribute :url, :name
  attr_accessor :account_id, :permalink
  
  collection_url "sites"
  member_url "accounts/:account_id/sites/:permalink"
  
  def save(&block)
    put(member_url, :payload => { :site => attributes }, &block)
  end
  
  def create(&block)
    post(collection_url, :payload => { :site => attributes }) do |response, json|
      block.call Site.new(json)
    end
  end
  
  def destroy(&block)
    delete(member_url, &block)
  end
  
  def health_checks(&block)
    block.call(@health_checks) and return if @health_checks
    
    HealthCheck.find_all(:account_id => account_id, :site_permalink => permalink) do |results|
      results.each do |result|
        result.site = self
      end
      @health_checks = results
      block.call(results)
    end
  end
end
