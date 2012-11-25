module RemoteModule
  class RemoteModel
    def save(&block)
      self.class.put(member_url, :payload => { self.class.name.underscore => attributes }) do |response, json|
        block.call json ? self.class.instantiate(json) : nil if block
      end
    end
  
    def create(&block)
      self.class.post(collection_url, :payload => { self.class.name.underscore => attributes }) do |response, json|
        block.call json ? self.class.instantiate(json) : nil if block
      end
    end
  
    def destroy(&block)
      self.class.delete(member_url) do |response, json|
        block.call json ? self.class.instantiate(json) : nil if block
      end
    end
    
    def reload(&block)
      self.class.get(member_url) do |response, json|
        block.call json ? self.class.instantiate(json) : nil if block
      end
    end
  end
end
