module MotionResource
  class Base
    class << self
      def identity_map
        @identity_map ||= {}
      end
      
      def remember(id, value)
        identity_map[id] = value
      end
      
      def recall(id)
        identity_map[id]
      end
    end
  end
end
