class User < MotionResource::Base
  attr_accessor :role, :full_name, :current_account_id, :email
  
  self.member_url = "users/:id"
  
  cattr_accessor :current
  
  has_many :accounts
  
  def initialize(*args)
    super
    extend Role.const_get(String.new(role || "user").camelize)
  end
  
  def gravatar_url(options = {})
    hash = NSData.MD5HexDigest(email.strip.downcase.dataUsingEncoding(NSUTF8StringEncoding))
    "http://www.gravatar.com/avatar/#{hash}.png?s=#{options[:size] || 40}"
  end
end
