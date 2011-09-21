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
      @_resources[name].add_context :view
    end
    helper_method name
    hide_action name
  end

  alias_method :view_expose, :expose
end

