module MotionResource
  class Base
    attr_accessor :id, :new_record
    
    def initialize(params = {})
      @new_record = true
      update_attributes(params)
    end
    
    class << self
      def instantiate(json)
        klass = if json[:type]
          begin
            Object.const_get(json[:type].to_s)
          rescue NameError
            self
          end
        else
          self
        end
        
        if result = klass.recall(json[:id])
          result.update_attributes(json)
        else
          result = klass.new(json)
          klass.remember(result.id, result)
        end
        result.new_record = false
        result
      end
    end
  end
end
