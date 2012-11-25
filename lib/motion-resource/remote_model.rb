module RemoteModule
  class RemoteModel
    HTTP_METHODS = [:get, :post, :put, :delete]

    class << self
      # These three methods (has_one/many/ + belongs_to)
      # map a symbol to a class for method_missing lookup 
      # for each :symbol in params.
      # Can also be used to view the current mappings:
      # EX
      # Question.has_one
      # => {:user => User}

      # EX 
      # self.has_one :question, :answer, :camel_case
      # => {:question => Question, :answer => Answer, :camel_case => CamelCase}
      def has_one(params = [])
        make_fn_lookup "has_one", params, singular_klass_str_lambda
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

      def method_missing(method, *args, &block)
        if self.custom_urls.has_key? method
          return self.custom_urls[method].format(args && args[0], self)
        end

        super
      end

      private
      # This is kind of neat.
      # Because models can be mutually dependent (User has a Question, Question has a User),
      # sometimes RubyMotion hasn't loaded the classes when this is run.
      # SO we check to see if the class is loaded; if not, then we just add it to the
      # namespace to make everything run smoothly and assume that by the time the app is running,
      # all the classes have been loaded.
      def make_klass(klass_str)
        begin
          klass = Object.const_get(klass_str)
        rescue NameError => e
          klass = Object.const_set(klass_str, Class.new(RemoteModule::RemoteModel))
        end
      end

      def singular_klass_str_lambda
        lambda { |sym| sym.to_s.split("_").collect {|s| s.capitalize}.join }
      end

      # How we fake define_method, essentially.
      # ivar_suffix -> what is the new @ivar called
      # params -> the :symbols to map to classes
      # transform -> how we transform the :symbol into a class name
      def make_fn_lookup(ivar_suffix, params, transform)
        ivar = "@" + ivar_suffix
        if !instance_variable_defined? ivar
          instance_variable_set(ivar, {})
        end
        
        sym_to_klass_sym = {}
        if params.class == Symbol
          sym_to_klass_sym[params] = transform.call(params)
        elsif params.class == Array
          params.each {|klass_sym|
            sym_to_klass_sym[klass_sym] = transform.call(klass_sym)
          }
        else
          params.each { |fn_sym, klass_sym| params[fn_sym] = singular_klass_str_lambda.call(klass_sym) }
          sym_to_klass_sym = params
        end

        sym_to_klass_sym.each do |relation_sym, klass_sym|
            klass_str = klass_sym.to_s
            instance_variable_get(ivar)[relation_sym] = make_klass(klass_str)
          end

        instance_variable_get(ivar)
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

    def remote_model_methods
      methods = []
      [self.class.has_one].each {|fn_hash|
        methods += fn_hash.collect {|sym, klass|
          [sym, (sym.to_s + "=:").to_sym, ("set" + sym.to_s.capitalize).to_sym]
        }.flatten
      }
      methods + RemoteModule::RemoteModel::HTTP_METHODS
    end

    def methods
      super + remote_model_methods
    end

    def respond_to?(symbol, include_private = false)
      if remote_model_methods.include? symbol
        return true
      end

      super
    end

    def method_missing(method, *args, &block)
      # Check for custom URLs
      if self.class.custom_urls.has_key? method
        return self.class.custom_urls[method].format(args && args[0], self)
      end

      # has_one relationships
      if self.class.has_one.has_key?(method)
        return instance_variable_get("@" + method.to_s)
      elsif setter_vals = setter_klass(self.class.has_one, method)
        klass, hash_symbol = setter_vals
        obj = args[0]
        if obj.class != klass
          obj = klass.new(obj)
        end
        return instance_variable_set("@" + hash_symbol.to_s, obj)
      end

      # HTTP methods
      if RemoteModule::RemoteModel::HTTP_METHODS.member? method
        return self.class.send(method, *args, &block)
      end

      super
    end

    private
    # PARAMS For a given method symbol, look through the hash
    #   (which is a map of :symbol => Class)
    #   and see if that symbol applies to any keys.
    # RETURNS an array [Klass, symbol] for which the original
    #   method symbol applies.
    # EX
    # setter_klass({:answers => Answer}, :answers=)
    # => [Answer, :answers]
    # setter_klass({:answers => Answer}, :setAnswers)
    # => [Answer, :answers]
    def setter_klass(hash, symbol)

      # go ahead and guess it's of the form :symbol=:
      hash_symbol = symbol.to_s[0..-2].to_sym

      # if it's the ObjC style setSymbol, change it to that.
      if symbol[0..2] == "set"
        # handles camel case arguments. ex setSomeVariableLikeThis => some_variable_like_this
        hash_symbol = symbol.to_s[3..-1].split(/([[:upper:]][[:lower:]]*)/).delete_if(&:empty?).map(&:downcase).join("_").to_sym
      end

      klass = hash[hash_symbol]
      if klass.nil?
        return nil
      end
      [klass, hash_symbol]
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
