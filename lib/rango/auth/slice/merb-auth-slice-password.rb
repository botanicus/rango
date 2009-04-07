if defined?(Rango::Plugins)

  $:.unshift File.dirname(__FILE__)

  require 'merb-slices'
  require 'merb-auth-core'
  require 'merb-auth-more'

  Rango::Plugins.add_rakefiles "merb-auth-slice-password/merbtasks", "merb-auth-slice-password/slicetasks", "merb-auth-slice-password/spectasks"

  # Register the Slice for the current host application
  Rango::Slices::register(__FILE__)

  # Slice configuration - set this in a before_app_loads callback.
  # By default a Slice uses its own layout, so you can swicht to
  # the main application layout or no layout at all if needed.
  #
  # Configuration options:
  # :layout - the layout to use; defaults to :mauth_password_slice
  # :mirror - which path component types to use on copy operations; defaults to all
  Rango::Slices::config[:"merb-auth-slice-password"][:layout] ||= :application

  # All Slice code is expected to be namespaced inside a module
  class RangoAuthSlicePassword

    # Slice metadata
    self.description = "Rango::AuthSlicePassword is a merb slice that provides basic password based logins"
    Gem.loaded_specs["merb-auth-slice-password"].version.version rescue Rango::VERSION
    self.author = "Daniel Neighman"

    # Stub classes loaded hook - runs before LoadClasses BootLoader
    # right after a slice's classes have been loaded internally.
    def self.loaded
    end

    # Initialization hook - runs before AfterAppLoads BootLoader
    def self.init
      require 'merb-auth-more/mixins/redirect_back'
      unless Rango::AuthSlicePassword[:no_default_strategies]
        ::Rango::Authentication.activate!(:default_password_form)
      end
    end

    # Activation hook - runs after AfterAppLoads BootLoader
    def self.activate
      # Load the default strategies
    end

    # Deactivation hook - triggered by Rango::Slices.deactivate(Rango::AuthSlicePassword)
    def self.deactivate
    end

    # Setup routes inside the host application
    #
    # @param scope<Rango::Router::Behaviour>
    #  Routes will be added within this scope (namespace). In fact, any
    #  router behaviour is a valid namespace, so you can attach
    #  routes at any level of your router setup.
    #
    # @note prefix your named routes with :mauth_password_slice_
    #   to avoid potential conflicts with global named routes.
    def self.setup_router(scope)
      # example of a named route
      scope.match("/login", :method => :get ).to(:controller => "/exceptions",  :action => "unauthenticated").name(:login)
      scope.match("/login", :method => :put ).to(:controller => "sessions",     :action => "update"         ).name(:perform_login)
      scope.match("/logout"                 ).to(:controller => "sessions",     :action => "destroy"        ).name(:logout)
    end

  end

  # Setup the slice layout for Rango::AuthSlicePassword
  #
  # Use Rango::AuthSlicePassword.push_path and Rango::AuthSlicePassword.push_app_path
  # to set paths to mauth_password_slice-level and app-level paths. Example:
  #
  # Rango::AuthSlicePassword.push_path(:application, Rango::AuthSlicePassword.root)
  # Rango::AuthSlicePassword.push_app_path(:application, Rango::.root / 'slices' / 'mauth_password_slice')
  # ...
  #
  # Any component path that hasn't been set will default to Rango::AuthSlicePassword.root
  #
  # Or just call setup_default_structure! to setup a basic Rango:: MVC structure.
  Rango::AuthSlicePassword.setup_default_structure!

  # Add dependencies for other Rango::AuthSlicePassword classes below. Example:
  # dependency "mauth_password_slice/other"

end
