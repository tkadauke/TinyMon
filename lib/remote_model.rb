module RemoteModule
  class RemoteModel
    class << self
      def attributes
        @attributes ||= []
      end
      
      def attributes=(value)
        @attributes = value
      end
      
      def attribute(*fields)
        attr_accessor *fields
        self.attributes += fields
      end
    end
    
    def attributes
      self.class.attributes.inject({}) do |hash, attr|
        hash[attr] = send(attr)
        hash
      end
    end
  end
end
