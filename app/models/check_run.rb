class CheckRun < RemoteModule::RemoteModel
  attr_accessor :health_check_id, :created_at, :ended_at, :deployment_id, :log, :account_id, :id, :error_message, :user_id, :started_at, :status, :duration
  
  collection_url "accounts/:account_id/sites/:site_permalink/health_checks/:check_permalink/check_runs"
  
  custom_urls :recent_url => "check_runs/recent"
  
  belongs_to :health_check
  
  def site_permalink
    health_check && health_check.site && health_check.site.permalink
  end
  
  def check_permalink
    health_check && health_check.permalink
  end
  
  def self.recent(&block)
    get(recent_url) do |response, json|
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
