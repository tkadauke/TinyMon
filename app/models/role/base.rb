module Role::Base
  module ClassMethods
    def allow(*things)
      things.each do |thing|
        define_method "can_#{thing}?" do
          true
        end
      end
    end
    
    def allow_if_owner(*things)
      things.each do |thing|
        define_method "can_#{thing}?" do |model|
          model.user == self
        end
      end
    end
  end
  
  def self.included(base)
    base.extend ClassMethods
  end
end
