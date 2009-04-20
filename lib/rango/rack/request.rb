# coding: utf-8

# Rack env keys (localhost, url /test):
# SERVER_SOFTWARE: thin 1.0.0 codename That's What She Said
# rack.input: #<StringIO:0x44cb7c>
# rack.version: [0, 3]
# rack.errors: #<IO:<STDERR>>
# rack.multithread: false
# rack.multiprocess: false
# rack.run_once: false
# REQUEST_METHOD: GET
# PATH_INFO: /test
# PATH_INFO: /test
# REQUEST_URI: /test
# HTTP_VERSION: HTTP/1.1
# HTTP_HOST: localhost:3000
# HTTP_USER_AGENT: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; en-US; rv:1.9.0.7) Gecko/2009021906 Firefox/3.0.7
# HTTP_ACCEPT: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
# HTTP_ACCEPT_LANGUAGE: en-us,en;q=0.5
# HTTP_ACCEPT_ENCODING: gzip,deflate
# HTTP_ACCEPT_CHARSET: UTF-8,*
# HTTP_KEEP_ALIVE: 300
# HTTP_CONNECTION: keep-alive
# HTTP_COOKIE: _session_id=BAh7CCIJdXNlciIbYWRtaW5AbWVnYXNhbW9sZXBreS5jeiIeYXV0aGVudGlj%250AYXRpb25fc3RyYXRlZ2llczAiDnJldHVybl90bzA%253D--e22dfc52e97832a60c396b743d03c1c48a4ca294
# HTTP_X_FIRELOGGER: 0.3
# GATEWAY_INTERFACE: CGI/1.2
# SERVER_NAME: localhost
# SERVER_PORT: 3000
# QUERY_STRING:
# SERVER_PROTOCOL: HTTP/1.1
# rack.url_scheme: http
# SCRIPT_NAME:
# REMOTE_ADDR: 127.0.0.1

# TODO: specs
# http://rack.rubyforge.org/doc/
# http://rack.rubyforge.org/doc/classes/Rack/Request.html
class Rango
  module Session
  end

  class Request < Rack::Request
    # @since 0.0.1
    # @return [Hash] Original Rack environment.
    attr_reader :env

    # @since 0.0.2
    attribute :message, Hash.new

    # @since 0.0.1
    # @example: blog/post/rango-released
    # @return [Hash] Original Rack environment.
    attr_reader :path

    # @since 0.0.1
    # @param [Hash] env Rack environment.
    def initialize(env)
      @env  = env
      # /path will be transformed to path/
      @path = env["PATH_INFO"]
      @path.chomp!("/") if @path.length > 1 # so let the / just if the path is only /
      @method = env["REQUEST_METHOD"].downcase
      self.extend_session
    end
    
    def GET
      super.deep_symbolize_keys.except(:_method)
    end
    
    def POST
      super.deep_symbolize_keys.except(:_method) if self.post?
    end
    
    def PUT
      if self.put?
        if @env["rack.request.form_input"].eql? @env["rack.input"]
          @env["rack.request.form_hash"]
        elsif form_data?
          @env["rack.request.form_input"] = @env["rack.input"]
          unless @env["rack.request.form_hash"] =
              Utils::Multipart.parse_multipart(env)
            @env["rack.request.form_vars"] = @env["rack.input"].read
            @env["rack.request.form_hash"] = Utils.parse_query(@env["rack.request.form_vars"])
            @env["rack.input"].rewind if @env["rack.input"].respond_to?(:rewind)
          end
          @env["rack.request.form_hash"].deep_symbolize_keys.except(:_method)
        else
          {}
        end
      end
    end
    
    def DELETE
      {}.deep_symbolize_keys.except(:_method)
    end
    
    def params
      @params = Hash.new
      [self.GET, self.POST, self.PUT, self.DELETE].each do |data|
        @params.merge!(data) if data.respond_to?(:merge) # Hash, Mash and friends
      end
      @params.deep_symbolize_keys.except(:msg, :_method)
    end

    def cookies
      super.except("rack.session").symbolize_keys
    end

    def form
      data = env["rack.request.form_hash"] || Hash.new
      data.deep_symbolize_keys.except(:_method)
    end
    
    def session
      Rango.logger.inspect(session: @env['rack.session'])
      @env['rack.session'] ||= {}
    end
    
    def ajax?
      env["HTTP_X_REQUESTED_WITH"] == "XMLHttpRequest"
    end

    def extend_session
      class << session
        include Rango::Session
      end
    end

    # @since 0.0.1
    # @example: "cz"
    # @return [String] Top level domain.
    def tld
      host.match(/^localhost/) ? nil : host.split(".").last
    end

    # @since 0.0.1
    # @example: "101ideas.cz"
    # @return [String] Domain name.
    def domain
      if host.match(/^localhost/)
        return host.split(".").last
      else
        return host.split(".").last(2).join(".")
      end
    end

    # @since 0.0.1
    # @example: "blog" or "user.blog"
    # @return [String] Subdomain name.
    def subdomain
      parts = host.split(".")
      index = parts.index(self.domain)
      parts[0..(index - 1)]
    end
    
    def base_url
      require "uri"
      fragments = URI.split("http://localhost:2000/foo/bar?q=foo")
      fragments = fragments[0..4]
      5.times { fragments.push(nil) }
      URI::HTTP.new(*fragments).to_s
    end
  end
end
