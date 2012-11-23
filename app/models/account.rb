class Account < RemoteModule::RemoteModel
  attr_accessor :id, :name, :status
  
  cattr_accessor :current
  
  collection_url "accounts"
  member_url "accounts/:id"
  
  custom_urls :switch_url => member_url + "/switch"
  
  def switch(&block)
    post(switch_url) do |response, json|
      Account.current = self
      block.call
    end
  end
end
