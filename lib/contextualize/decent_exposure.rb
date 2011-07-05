module DecentExposure
  def expose(name, &block)
    closured_exposure = default_exposure
    define_method name do
      @_resources       ||= {}
      @_resources[name] ||= if block_given?
        instance_eval(&block)
      else
        instance_exec(name, &closured_exposure)
      end
      puts "expose contextualize"
      @_resources[name].add_icontext :view
    end
    helper_method name
    hide_action name
  end
  
  alias_method :view_expose, :expose
end
  