# Rack env keys (localhost, url /test):
# SERVER_SOFTWARE: thin 1.0.0 codename That's What She Said
# rack.input: #<StringIO:0x44cb7c>
# rack.version: [0, 3]
# rack.errors: #<IO:<STDERR>>
# rack.multithread: false
# rack.multiprocess: false
# rack.run_once: false
# REQUEST_METHOD: GET
# REQUEST_PATH: /test
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
      @method = env["REQUEST_METHOD"]
    end
    
    def params
      {:method => @method}
    end
  end
end
