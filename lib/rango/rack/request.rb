# encoding: utf-8

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

require "rack"
require "rango/core_ext"

module Rango
  module Session
  end

  class Request < ::Rack::Request
    # @since 0.0.1
    # @return [Hash] Original Rack environment.
    attr_reader :env

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
      @path.chomp!("/") if @path && @path.length > 1 # so let the / just if the path is only /
      @method = (env["REQUEST_METHOD"] || String.new).downcase
      session.extend(Session)
      Rango.logger.debug("Session: #{@env['rack.session'].inspect}")
    end

    def GET
      ParamsMixin.convert(super)
    end

    def POST
      ParamsMixin.convert(super)
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
          ParamsMixin.convert(@env["rack.request.form_hash"])
        else
          {}
        end
      end
    end

    def params
      @params ||= begin
        input = [self.GET, self.POST, self.PUT]
        ParamsMixin.convert(
          input.inject(Hash.new) do |result, hash|
            hash ? result.merge!(hash) : result
          end
        )
      end
    end

    def cookies
      super.tap { |cookies| cookies.delete("rack.session") }.symbolize_keys
    end

    def form
      ParamsMixin.convert(env["rack.request.form_hash"] || Hash.new)
    end

    def session
      @env['rack.session'] ||= {}
    end

    alias_method :ajax?, :xhr?

    # @since 0.0.1
    # @example: "cz"
    # @return [String] Top level domain.
    def tld
      host.match(/^localhost/) ? nil : host.split(".").last
    end

    # @since 0.0.1
    # @example: "101ideas.cz"
    # @return [String] Domain name.
    # FIXME: what about .co.uk? Rewrite in the same way as subdomains
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
    def subdomains(tld_length = 1) # we set tld_length to 1, use 2 for co.uk or similar
      # cache the result so we only compute it once.
      @env['rack.env.subdomains'] ||= begin
        # check if the current host is an IP address, if so return an empty array
        return [] if (host.nil? ||
                      /\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/.match(host))
        host.split('.')[0...(1 - tld_length - 2)] # pull everything except the TLD
      end
    end

    def base_url
      url = scheme + "://"
      url << host
      if scheme == "https" && port != 443 ||
          scheme == "http" && port != 80
        url << ":#{port}"
      end
      url
    end
  end
end
