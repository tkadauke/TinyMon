class CheckEmailStep < Step
  data_attribute :server, :login, :password
  
  def summary
    "Check E-Mail"
  end
  
  def detail
    "with login '#{login}' on server '#{server}'"
  end
end
