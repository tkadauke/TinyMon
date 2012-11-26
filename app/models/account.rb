class Account < MotionResource::Base
  attr_accessor :id, :name, :status, :role
  
  cattr_accessor :current
  
  self.collection_url = "accounts"
  self.member_url = "accounts/:id"
  
  custom_urls :switch_url => member_url + "/switch"
  
  def initialize(*args)
    super
    extend Role::Account.const_get(String.new(role).camelize) if role
  end
  
  def switch(&block)
    self.class.post(switch_url) do |response, json|
      Account.current = self
      block.call
    end
  end
end
