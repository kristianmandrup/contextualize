require 'mixology'
require 'active_support/inflector'
require 'contextualize/core_ext'

module Contextualize

  module ClassMethods
    attr_reader :icontext_map

    def icontext name, *constants
      @icontext_map ||= {}
      @icontext_map[name.to_sym] = select_modules constants
    end

    def icontexts *names
      names.flatten.each do |name|
        icontext name, const_by_convention(name)
      end
    end

    protected

    def const_by_convention name
      cls_name = self.name.demodulize
      const_name = "Contextualize::#{cls_name}#{name.to_s.camelize}"
      const_name.constantize
    end

    def select_modules constants
      constants.select {|c| c.is_a?(Module) && !c.respond_to?(:new) }
    end
  end

  def self.included base
    base.extend ClassMethods
  end

  def icontext_map
    self.class.icontext_map || {}
  end

  def add_icontexts *names
    names.each {|name| add_icontext(name) }
  end

  def remove_icontexts *names
    names.each {|name| remove_icontext(name) }
  end

  def add_icontext name
    icontext(name).each do |const|
      self.send :mixin, const 
    end
  end

  def remove_icontext name
    return if !icontext(name) || icontext(name).empty? 
    icontext(name).each do |const|
      self.send :unmix, const
    end
  end

  protected

  def icontext name 
    icontext_map[name.to_sym] || []
  end  
end
