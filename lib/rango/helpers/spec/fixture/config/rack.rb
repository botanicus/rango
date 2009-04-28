# use PathPrefix Middleware if :path_prefix is set in Rango::Config
if prefix = ::Rango::Config[:path_prefix]
  use Rango::Rack::PathPrefix, prefix
end

# comment this out if you are running merb behind a load balancer
# that serves static files
use Rango::Rack::Static, Rango.dir_for(:public)

# this is our main merb application
run Rango::Rack::Application.new
