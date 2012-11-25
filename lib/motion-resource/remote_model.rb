module RemoteModule
  class RemoteModel
    HTTP_METHODS = [:get, :post, :put, :delete]

    class << self
      def has_one(name)
        define_method name do
          instance_variable_get("@#{name}")
        end
        
        define_method "#{name}=" do |value|
          klass = Object.const_get(name.to_s.classify)
          value = klass.new(value) if value.is_a?(Hash)
          instance_variable_set("@#{name}", value)
        end
        
        define_method "reset_#{name}" do
          instance_variable_set("@#{name}", nil)
        end
      end

      def has_many(name, params = lambda { nil })
        backwards_association = self.name.underscore
        
        define_method name do |&block|
          if block.nil?
            instance_variable_get("@#{name}") || []
          else
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
        end
        
        define_method "#{name}=" do |array|
          klass = Object.const_get(name.to_s.classify)
          instance_variable_set("@#{name}", []) if instance_variable_get("@#{name}").blank?
          
          array.each do |value|
            value = klass.new(value) if value.is_a?(Hash)
            instance_variable_get("@#{name}") << value
          end
        end
        
        define_method "reset_#{name}" do
          instance_variable_set("@#{name}", nil)
        end
      end

      def belongs_to(name, params = lambda { nil })
        define_method name do |&block|
          if block.nil?
            instance_variable_get("@#{name}")
          else
            cached = instance_variable_get("@#{name}")
            block.call(cached) and return if cached
          
            Object.const_get(name.to_s.classify).find(self.send("#{name}_id"), params.call(self)) do |result|
              instance_variable_set("@#{name}", result)
              block.call(result)
            end
          end
        end
        
        define_method "#{name}=" do |value|
          klass = Object.const_get(name.to_s.classify)
          value = klass.new(value) if value.is_a?(Hash)
          instance_variable_set("@#{name}", value)
        end
        
        define_method "reset_#{name}" do
          instance_variable_set("@#{name}", nil)
        end
      end
    end

    def initialize(params = {})
      update_attributes(params)
    end

    def update_attributes(params = {})
      attributes = self.methods - Object.methods
      params.each do |key, value|
        if attributes.member?((key.to_s + "=:").to_sym)
          self.send((key.to_s + "=:").to_sym, value)
        end
      end
    end

    def method_missing(method, *args, &block)
      # HTTP methods
      if RemoteModule::RemoteModel::HTTP_METHODS.member? method
        return self.class.send(method, *args, &block)
      end

      super
    end
    
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
      
      def scope(name)
        metaclass.send(:define_method, name) do |&block|
          get(send("#{name}_url")) do |response, json|
            if response.ok?
              objs = []
              arr_rep = nil
              if json.class == Array
                arr_rep = json
              elsif json.class == Hash
                plural_sym = self.name.pluralize.to_sym
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
    end
    
    public
    def attributes
      self.class.attributes.inject({}) do |hash, attr|
        hash[attr] = send(attr)
        hash
      end
    end
    
    def save(&block)
      self.class.put(member_url, :payload => { self.class.name.underscore => attributes }) do |response, json|
        block.call json ? self.class.new(json) : nil
      end
    end
  
    def create(&block)
      self.class.post(collection_url, :payload => { self.class.name.underscore => attributes }) do |response, json|
        block.call json ? self.class.new(json) : nil
      end
    end
  
    def destroy(&block)
      self.class.delete(member_url) do |response, json|
        block.call json ? self.class.new(json) : nil
      end
    end
    
    def reload(&block)
      self.class.get(member_url) do |response, json|
        block.call json ? self.class.new(json) : nil
      end
    end
  end
end
