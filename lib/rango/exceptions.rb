# encoding: utf-8

# http://wiki.github.com/botanicus/rango/errors-handling

require "uri"

# superclass of all the controller exceptions
module Rango
  module Exceptions
    class HttpError < StandardError
      def self.name=(name)
        @name = name
      end

      def self.name
        @name
      end

      def name
        @name ||= self.class.name
      end

      def self.message=(message)
        @message = message
      end

      # backtrace isn't writable, but we want to set it time to time, see Controller.call
      attr_writer :backtrace
      def backtrace
        super || @backtrace
      end

      def self.message
        @message ||= begin
          self.superclass.message
        rescue NoMethodError
        end
      end

      attr_writer :message
      def message
        @message ||= self.class.message
      end

      def self.status=(status)
        @status = status
      end

      def self.status
        @status ||= begin
          self.superclass.status
        rescue NoMethodError
        end
      end

      # If we have a redirection but we don't know the status yet,
      # then rather than use raise Error301 we create a new instance
      # of the Redirection class and set the status manualy
      attr_writer :status

      def status
        @status ||= self.class.status
      end

      def self.headers
        @headers ||= {"Content-Type" => "text/html"}
      end

      def headers
        @headers ||= self.class.headers.dup
      end

      # raise Redirection.new("/", 301)
      def initialize(message = self.class.name, status = nil)
        self.status = status unless status.nil?
        self.message = message
      end

      def inspect
        self.to_response.inspect
      end

      # @returns [String]
      # @example NotFound.new.to_snakecase # "not_found"
      def to_snakecase
        self.class.name.gsub(" ", "_").downcase
      end

      def to_response
        [self.status, self.headers, [self.message].compact]
      end
    end

    # http://en.wikipedia.org/wiki/List_of_HTTP_status_codes

    # informational
    Informational = Class.new(HttpError)
    Error100 = Continue = Class.new(Informational)                 { self.status ||= 100; self.name ||= "Continue" }
    Error101 = SwitchingProtocols = Class.new(Informational)       { self.status ||= 101; self.name ||= "Switching Protocols" }

    # successful
    Successful = Class.new(HttpError)
    Error200 = OK = Class.new(Successful)                          { self.status ||= 200; self.name ||= "OK" }
    Error201 = Created = Class.new(Successful)                     { self.status ||= 201; self.name ||= "Created" }
    Error202 = Accepted = Class.new(Successful)                    { self.status ||= 202; self.name ||= "Accepted" }
    Error203 = NonAuthoritativeInformation = Class.new(Successful) { self.status ||= 203; self.name ||= "Non Authoritative Information" }
    Error204 = NoContent = Class.new(Successful)                   { self.status ||= 204; self.name ||= "No Content" }
    Error205 = ResetContent = Class.new(Successful)                { self.status ||= 205; self.name ||= "Reset Content" }
    Error206 = PartialContent = Class.new(Successful)              { self.status ||= 206; self.name ||= "Partial Content" }

    # redirection
    class Redirection < HttpError
      self.name ||= "Redirection"
      alias_method :location, :message

      def body
        %{Please follow <a href="#{URI.escape(self.location)}">#{self.location}</a>}
      end

      def to_response
        super.tap do |response|
          response[2] = [self.body]
        end
      end

      # use raise MovedPermanently, "http://example.com"
      # Yes, you can use just redirect method from the controller, but
      # this will work even in filters or in environments without controllers
      # raise Redirection.new("/", 301)
      def initialize(location, status = nil)
        super(location, status)
        location = URI.escape(location)
        headers["Location"] = location
      end
    end

    Error300 = MultipleChoices = Class.new(Redirection)             { self.status ||= 300; self.name ||= "Multiple Choices" }
    Error301 = MovedPermanently = Class.new(Redirection)            { self.status ||= 301; self.name ||= "Moved Permanently" }
    Error302 = MovedTemporarily = Class.new(Redirection)            { self.status ||= 302; self.name ||= "Moved Temporarily" }
    Error303 = SeeOther = Class.new(Redirection)                    { self.status ||= 303; self.name ||= "See Other" } # this is the redirect you want to use after POST
    Error304 = NotModified = Class.new(Redirection)                 { self.status ||= 304; self.name ||= "Not Modified" }
    Error305 = UseProxy = Class.new(Redirection)                    { self.status ||= 305; self.name ||= "Use Proxy" }
    Error307 = TemporaryRedirect = Class.new(Redirection)           { self.status ||= 307; self.name ||= "Temporary Redirect" }

    # client error
    ClientError = Class.new(HttpError)
    Error400 = BadRequest = Class.new(ClientError)                  { self.status ||= 400; self.name ||= "Bad Request" }
    MultiPartParseError = Class.new(BadRequest)
    Error401 = Unauthorized = Class.new(ClientError)                { self.status ||= 401; self.name ||= "Unauthorized" }
    Error402 = PaymentRequired = Class.new(ClientError)             { self.status ||= 402; self.name ||= "Payment Required" }
    Error403 = Forbidden = Class.new(ClientError)                   { self.status ||= 403; self.name ||= "Forbidden" }
    Error404 = NotFound = Class.new(ClientError)                    { self.status ||= 404; self.name ||= "Not Found" }
    ActionNotFound = Class.new(NotFound)
    Error405 = MethodNotAllowed = Class.new(ClientError)            { self.status ||= 405; self.name ||= "Method Not Allowed" }
    Error406 = NotAcceptable = Class.new(ClientError)               { self.status ||= 406; self.name ||= "Not Acceptable" }
    Error407 = ProxyAuthenticationRequired = Class.new(ClientError) { self.status ||= 407; self.name ||= "Proxy Authentication Required" }
    Error408 = RequestTimeout = Class.new(ClientError)              { self.status ||= 408; self.name ||= "Request Timeout" }
    Error409 = Conflict = Class.new(ClientError)                    { self.status ||= 409; self.name ||= "Conflict" }
    Error410 = Gone = Class.new(ClientError)                        { self.status ||= 410; self.name ||= "Gone" }
    Error411 = LengthRequired = Class.new(ClientError)              { self.status ||= 411; self.name ||= "Length Required" }
    Error412 = PreconditionFailed = Class.new(ClientError)          { self.status ||= 412; self.name ||= "Precondition Failed" }
    Error413 = RequestEntityTooLarge = Class.new(ClientError)       { self.status ||= 413; self.name ||= "Request Entity Too Large" }
    Error414 = RequestURITooLarge = Class.new(ClientError)          { self.status ||= 414; self.name ||= "Request URI Too Large" }
    Error415 = UnsupportedMediaType = Class.new(ClientError)        { self.status ||= 415; self.name ||= "Unsupported Media Type" }
    Error416 = RequestRangeNotSatisfiable = Class.new(ClientError)  { self.status ||= 416; self.name ||= "Request Range Not Satisfiable" }
    Error417 = ExpectationFailed = Class.new(ClientError)           { self.status ||= 417; self.name ||= "Expectation Failed" }

    # server error
    ServerError = Class.new(HttpError)
    Error500 = InternalServerError = Class.new(ServerError)         { self.status ||= 500; self.name ||= "Internal Server Error" }
    Error501 = NotImplemented = Class.new(ServerError)              { self.status ||= 501; self.name ||= "Not Implemented" }
    Error502 = BadGateway = Class.new(ServerError)                  { self.status ||= 502; self.name ||= "Bad Gateway" }
    Error503 = ServiceUnavailable = Class.new(ServerError)          { self.status ||= 503; self.name ||= "Service Unavailable" }
    Error504 = GatewayTimeout = Class.new(ServerError)              { self.status ||= 504; self.name ||= "Gateway Timeout" }
    Error505 = HTTPVersionNotSupported = Class.new(ServerError)     { self.status ||= 505; self.name ||= "HTTP Version Not Supported" }
  end
end
