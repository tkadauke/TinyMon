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
        attr_reader *fields
        fields.each do |field|
          define_method "#{field}=" do |value|
            if value.is_a?(Hash) || value.is_a?(Array)
              instance_variable_set("@#{field}", value.dup)
            else
              instance_variable_set("@#{field}", value)
            end
          end
        end
        self.attributes += fields
      end
      
      def find_all(params = {}, &block)
        get(collection_url.format(params)) do |response, json|
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
              if one_obj_hash[:type]
                begin
                  klass = Object.const_get(one_obj_hash[:type].to_s)
                  objs << klass.new(one_obj_hash)
                rescue NameError
                  objs << self.new(one_obj_hash)
                end
              else
                objs << self.new(one_obj_hash)
              end
            }
            request_block_call(block, objs, response)
          else
            request_block_call(block, nil, response)
          end
        end
      end
      
      def association(name, params)
        backwards_association = self.name.underscore
        
        define_method name do |&block|
          cached = instance_variable_get("@#{name}")
          block.call(cached) and return if cached
          
          Object.const_get(name.to_s.classify).find_all(params.call(self)) do |results|
            if results
              results.each do |result|
                result.send("#{backwards_association}=", self)
              end
            end
            instance_variable_set("@#{name}", results)
            block.call(results)
          end
        end
    
        define_method "reset_#{name}" do
          instance_variable_set("@#{name}", nil)
        end
      end
      
      def scope(name)
        metaclass.send(:define_method, name) do |&block|
          get(send("#{name}_url")) do |response, json|
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
    
    def attributes
      self.class.attributes.inject({}) do |hash, attr|
        hash[attr] = send(attr)
        hash
      end
    end
    
    def save(&block)
      put(member_url, :payload => { self.class.name.underscore => attributes }) do |response, json|
        block.call json ? self.class.new(json) : nil
      end
    end
  
    def create(&block)
      post(collection_url, :payload => { self.class.name.underscore => attributes }) do |response, json|
        block.call json ? self.class.new(json) : nil
      end
    end
  
    def destroy(&block)
      delete(member_url) do |response, json|
        block.call json ? self.class.new(json) : nil
      end
    end
  end
end
