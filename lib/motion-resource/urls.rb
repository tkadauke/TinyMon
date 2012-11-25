module RemoteModule
  class RemoteModel
    class_inheritable_accessor :collection_url, :member_url
    class_inheritable_accessor :root_url, :default_url_options
    cattr_writer :extension
    
    class << self
      def extension
        @extension || (self == RemoteModel ? false : RemoteModel.extension) || ".json"
      end
      
      def collection_url=(value)
        @collection_url = RemoteModule::FormatableString.new(value)
      end
      
      def member_url=(value)
        @member_url = RemoteModule::FormatableString.new(value)
      end
      
      def custom_urls(params = {})
        params.each do |name, url_format|
          define_method name do |params = {}|
            RemoteModule::FormatableString.new(url_format).format(params, self)
          end
          metaclass.send :define_method, name do
            RemoteModule::FormatableString.new(url_format)
          end
        end
      end
    end

    def collection_url(params = {})
      self.class.collection_url.format(params, self)
    end

    def member_url(params = {})
      self.class.member_url.format(params, self)
    end
  end
end
