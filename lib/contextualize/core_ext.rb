class Object
  def context_scope *names, &block
    self.add_contexts *names
    yield self if block
    self.remove_contexts *names
  end
end

class Array
  def add_context name
    self.each {|item| item.add_context name }
  end

  def remove_context name
    self.each {|item| item.remove_context name }
  end
end

class Module
  def contextualize
    self.send :include, Contextualize
  end
end


