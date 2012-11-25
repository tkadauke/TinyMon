class Class
  def class_inheritable_accessor(*fields)
    fields.each do |field|
      metaclass.send :define_method, field do
        ivar = instance_variable_get("@#{field}")
        ivar || (superclass.send(field) if superclass.respond_to?(field))
      end
    end
    
    cattr_writer *fields
  end
end
