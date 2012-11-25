module RemoteModule
  class RemoteModel
    class << self
      attr_accessor :root_url, :default_url_options
      attr_writer :extension

      def extension
        @extension || (self == RemoteModel ? false : RemoteModel.extension) || ".json"
      end
      
      class_inheritable_accessor :collection_url, :member_url
      
      def custom_urls(params = {})
        @custom_urls ||= {}
        params.each do |fn, url_format|
          @custom_urls[fn] = RemoteModule::FormatableString.new(url_format)
        end
        @custom_urls
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
        (self.root_url || RemoteModule::RemoteModel.root_url) + fragment +  self.extension
      end

      def http_call(method, url, call_options = {}, &block)
        options = call_options 
        options.merge!(RemoteModule::RemoteModel.default_url_options || {})
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
            json = BubbleWrap::JSON.parse(body.blank? ? "{}" : body)
            block.call response, json
          else
            block.call response, nil
          end
        end
      end
    end

    def collection_url(params = {})
      RemoteModule::FormatableString.new(self.class.collection_url).format(params, self)
    end

    def member_url(params = {})
      RemoteModule::FormatableString.new(self.class.member_url).format(params, self)
    end
  end
end