class Class
  def cattr_reader(*fields)
    metaclass.send :attr_reader, *fields
  end
  
  def cattr_writer(*fields)
    metaclass.send :attr_writer, *fields
  end
  
  def cattr_accessor(*fields)
    metaclass.send :attr_accessor, *fields
  end
end
