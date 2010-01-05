# encoding: utf-8

# http://wiki.github.com/botanicus/rango/errors-handling

# superclass of all the controller exceptions
module Rango
  module Exceptions
    class HttpError < StandardError
      CONTENT_TYPE ||= "text/html"

      attr_accessor :content_type, :headers
      def initialize(*args)
        @headers = Hash.new
        super(*args)
      end

      def inspect
        self.to_response.inspect
      end

      # @returns [String]
      # @example NotFound.new.to_snakecase # "not_found"
      def to_snakecase
        self.class.name.split("::").last.snake_case
      end

      def status
        self.class::STATUS
      end

      # If we have a redirection but we don't know the status yet,
      # then rather than use raise Error301 we create a new instance
      # of the Redirection class and set the status manualy
      def status=(status)
        self.class.const_set(:STATUS, status)
      end

      def content_type
        @content_type || self.class::CONTENT_TYPE
      end

      def to_response
        headers = {"Content-Type" => self.content_type}.merge(self.headers)
        [self.status, headers, [self.message]]
      end

      @@required_constants ||= [:STATUS, :CONTENT_TYPE]
      def self.const_missing(name)
        if @@required_constants.include?(name)
          raise NameError, "Every descendant of HttpError class has to have defined constant #{name}."
        else
          super(name)
        end
      end
    end

    # http://en.wikipedia.org/wiki/List_of_HTTP_status_codes

    # informational
    Informational = Class.new(Rango::Exceptions::HttpError)
    Error100 = Continue = Class.new(Rango::Exceptions::Informational) { STATUS ||= 100 }
    Error101 = SwitchingProtocols = Class.new(Rango::Exceptions::Informational) { STATUS ||= 101 }

    # successful
    Successful = Class.new(Rango::Exceptions::HttpError)
    Error200 = OK = Class.new(Rango::Exceptions::Successful) { STATUS ||= 200 }
    Error201 = Created = Class.new(Rango::Exceptions::Successful) { STATUS ||= 201 }
    Error202 = Accepted = Class.new(Rango::Exceptions::Successful) { STATUS ||= 202 }
    Error203 = NonAuthoritativeInformation = Class.new(Rango::Exceptions::Successful) { STATUS ||= 203 }
    Error204 = NoContent = Class.new(Rango::Exceptions::Successful) { STATUS ||= 204 }
    Error205 = ResetContent = Class.new(Rango::Exceptions::Successful) { STATUS ||= 205 }
    Error206 = PartialContent = Class.new(Rango::Exceptions::Successful) { STATUS ||= 206 }

    # redirection
    Redirection = Class.new(Rango::Exceptions::HttpError) {
      @@required_constants.push(:LOCATION)
      # use raise MovedPermanently, "http://example.com"
      # Yes, you can use just redirect method from the controller, but
      # this will work even in filters or in environments without controllers
      def initialize(location)
        super
        @headers["Location"] = URI.escape(location)
      end
    }

    Error300 = MultipleChoices = Class.new(Rango::Exceptions::Redirection) { STATUS ||= 300 }
    Error301 = MovedPermanently = Class.new(Rango::Exceptions::Redirection) { STATUS ||= 301 }
    Error302 = MovedTemporarily = Class.new(Rango::Exceptions::Redirection) { STATUS ||= 302 }
    Error303 = SeeOther = Class.new(Rango::Exceptions::Redirection) { STATUS ||= 303 }
    Error304 = NotModified = Class.new(Rango::Exceptions::Redirection) { STATUS ||= 304 }
    Error305 = UseProxy = Class.new(Rango::Exceptions::Redirection) { STATUS ||= 305 }
    Error307 = TemporaryRedirect = Class.new(Rango::Exceptions::Redirection) { STATUS ||= 307 }

    # client error
    ClientError = Class.new(Rango::Exceptions::HttpError)
    Error400 = BadRequest = Class.new(Rango::Exceptions::ClientError) { STATUS ||= 400 }
    MultiPartParseError = Class.new(Rango::Exceptions::BadRequest)
    Error401 = Unauthorized = Class.new(Rango::Exceptions::ClientError) { STATUS ||= 401 }
    Error402 = PaymentRequired = Class.new(Rango::Exceptions::ClientError) { STATUS ||= 402 }
    Error403 = Forbidden = Class.new(Rango::Exceptions::ClientError) { STATUS ||= 403 }
    Error404 = NotFound = Class.new(Rango::Exceptions::ClientError) { STATUS ||= 404 }
    ActionNotFound = Class.new(Rango::Exceptions::NotFound)
    Error405 = MethodNotAllowed = Class.new(Rango::Exceptions::ClientError) { STATUS ||= 405 }
    Error406 = NotAcceptable = Class.new(Rango::Exceptions::ClientError) { STATUS ||= 406 }
    Error407 = ProxyAuthenticationRequired = Class.new(Rango::Exceptions::ClientError) { STATUS ||= 407 }
    Error408 = RequestTimeout = Class.new(Rango::Exceptions::ClientError) { STATUS ||= 408 }
    Error409 = Conflict = Class.new(Rango::Exceptions::ClientError) { STATUS ||= 409 }
    Error410 = Gone = Class.new(Rango::Exceptions::ClientError) { STATUS ||= 410 }
    Error411 = LengthRequired = Class.new(Rango::Exceptions::ClientError) { STATUS ||= 411 }
    Error412 = PreconditionFailed = Class.new(Rango::Exceptions::ClientError) { STATUS ||= 412 }
    Error413 = RequestEntityTooLarge = Class.new(Rango::Exceptions::ClientError) { STATUS ||= 413 }
    Error414 = RequestURITooLarge = Class.new(Rango::Exceptions::ClientError) { STATUS ||= 414 }
    Error415 = UnsupportedMediaType = Class.new(Rango::Exceptions::ClientError) { STATUS ||= 415 }
    Error416 = RequestRangeNotSatisfiable = Class.new(Rango::Exceptions::ClientError) { STATUS ||= 416 }
    Error417 = ExpectationFailed = Class.new(Rango::Exceptions::ClientError) { STATUS ||= 417 }

    # server error
    ServerError = Class.new(Rango::Exceptions::HttpError)
    Error500 = InternalServerError = Class.new(Rango::Exceptions::ServerError) { STATUS ||= 500 }
    Error501 = NotImplemented = Class.new(Rango::Exceptions::ServerError) { STATUS ||= 501 }
    Error502 = BadGateway = Class.new(Rango::Exceptions::ServerError) { STATUS ||= 502 }
    Error503 = ServiceUnavailable = Class.new(Rango::Exceptions::ServerError) { STATUS ||= 503 }
    Error504 = GatewayTimeout = Class.new(Rango::Exceptions::ServerError) { STATUS ||= 504 }
    Error505 = HTTPVersionNotSupported = Class.new(Rango::Exceptions::ServerError) { STATUS ||= 505 }
  end
end
