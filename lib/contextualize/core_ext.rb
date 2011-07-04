class Object
  def own_methods
    methods - Object.methods
  end

  def icontext_scope *names, &block
    self.add_icontexts *names
    yield self if block
    self.remove_icontexts *names
  end
end

class Module
  def contextualize
    self.send :include, Contextualize
  end

  def own_methods
    instance_methods - Object.instance_methods
  end
end


