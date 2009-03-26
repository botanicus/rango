class Rango
  class Request
    attribute :env, Hash.new # original rack env
    attribute :headers, Hash.new
    attribute :domain
    attribute :subdomain
    attr_reader :path

    def initialize(env)
      @env  = env
      @path = env["REQUEST_PATH"]
    end
  end
end
