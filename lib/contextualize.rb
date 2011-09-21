require 'mixology'
require 'active_support/inflector'
require 'contextualize/core_ext'
require 'contextualize/decent_exposure'

module Contextualize
  module ClassMethods
    attr_reader :context_map

    def context name, *constants
      @context_map ||= {}
      context_modules = if constants.flatten.empty?
        const_by_convention(name)
      else
        select_modules constants
      end
      @context_map[name.to_sym] = context_modules
    end

    def contexts *names
      names.flatten.each do |name|
        context name, const_by_convention(name)
      end
    end

    protected

    def const_by_convention name
      cls_name = self.name.demodulize
      const_name = "#{cls_name}#{name.to_s.camelize}"
      const_name.constantize
    end

    def select_modules constants
      constants.select {|c| c.is_a?(Module) && !c.respond_to?(:new) }
    end
  end

  def self.included base
    base.extend ClassMethods
  end

  def context_map
    self.class.context_map || {}
  end

  def add_contexts *names
    names.each {|name| add_context(name) }
    self
  end
  alias_method :enter_contexts, :add_contexts

  def remove_contexts *names
    names.each {|name| remove_context(name) }
    self
  end
  alias_method :exit_contexts, :remove_contexts

  def add_context name
    context(name).each do |const|
      self.send :mixin, const
    end
    self
  end
  alias_method :enter_context, :add_context

  def remove_context name
    return if !context(name) || context(name).empty? 
    context(name).each do |const|
      self.send :unmix, const
    end
    self
  end
  alias_method :exit_context, :remove_context

  protected

  def context name
    mods = context_map[name.to_sym] || []
    [mods].flatten
  end
end
