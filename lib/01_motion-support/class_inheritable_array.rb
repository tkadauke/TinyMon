class Class
  def class_inheritable_array(*fields)
    fields.each do |field|
      metaclass.send :define_method, field do
        array = instance_variable_get("@#{field}") || []
        super_array = (superclass.send(field) if superclass.respond_to?(field)) || []
        [array, super_array].flatten
      end
    end
    
    cattr_writer *fields
  end
end
