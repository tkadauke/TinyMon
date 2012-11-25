module RemoteModule
  class RemoteModel
    HTTP_METHODS = [:get, :post, :put, :delete]

    HTTP_METHODS.each do |method|
      define_method method do |*args, &block|
        self.class.send(method, *args, &block)
      end
    end
    
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

      #################################
      # URL helpers (via BubbleWrap)
      # EX
      # Question.get(a_question.custom_url) do |response, json|
      #   p json
      # end
      def get(url, params = {}, &block)
        http_call(:get, url, params, &block)
      end

      def post(url, params = {}, &block)
        http_call(:post, url, params, &block)
      end

      def put(url, params = {}, &block)
        http_call(:put, url, params, &block)
      end

      def delete(url, params = {}, &block)
        http_call(:delete, url, params, &block)
      end

    private
      def complete_url(fragment)
        if fragment[0..3] == "http"
          return fragment
        end
        (self.root_url || RemoteModule::RemoteModel.root_url) + fragment
      end

      def http_call(method, url, call_options = {}, &block)
        options = call_options 
        options.merge!(RemoteModule::RemoteModel.default_url_options || {})
        url += self.extension
        if query = options.delete(:query)
          if url.index("?").nil?
            url += "?"
          end
          url += query.map{|k,v| "#{k}=#{v}"}.join('&')
        end
        if self.default_url_options
          options.merge!(self.default_url_options)
        end
        BubbleWrap::HTTP.send(method, complete_url(url), options) do |response|
          if response.ok?
            body = response.body.to_str.strip
            if body.blank?
              block.call(response, {})
            else
              block.call response, BubbleWrap::JSON.parse(body)
            end
          else
            block.call response, nil
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