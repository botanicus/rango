# encoding: utf-8

SettingsNotFound = Class.new(StandardError)

class TemplateNotFound < StandardError # TODO: should inherit from NotFound
  # @since 0.0.2
  attr_accessor :message

  # @since 0.0.2
  def initialize(template, locations)
    self.message = "Template '#{template}' wasn't found in any of these locations: #{locations.join(", ")}."
  end
end

# superclass of all the controller exceptions
module Rango
  class HttpError < StandardError
    CONTENT_TYPE ||= "text/plain"

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

    def status() self.class::STATUS end
    def content_type
      @content_type || self.class::CONTENT_TYPE
    end

    def to_response
      headers = self.headers.reverse_merge("Content-Type" => self.content_type)
      [self.status, headers, [self.message]]
    end

    def self.const_missing(name)
      if [:STATUS, :CONTENT_TYPE].include?(name)
        raise NameError, "Every descendant of HttpError class has to have defined constant #{name}."
      else
        super(name)
      end
    end
  end

  # http://en.wikipedia.org/wiki/List_of_HTTP_status_codes

  # informational
  Informational = Class.new(Rango::HttpError)
  Error100 = Continue = Class.new(Rango::Informational) { STATUS ||= 100 }
  Error101 = SwitchingProtocols = Class.new(Rango::Informational) { STATUS ||= 101 }

  # successful
  Successful = Class.new(Rango::HttpError)
  Error200 = OK = Class.new(Rango::Successful) { STATUS ||= 200 }
  Error201 = Created = Class.new(Rango::Successful) { STATUS ||= 201 }
  Error202 = Accepted = Class.new(Rango::Successful) { STATUS ||= 202 }
  Error203 = NonAuthoritativeInformation = Class.new(Rango::Successful) { STATUS ||= 203 }
  Error204 = NoContent = Class.new(Rango::Successful) { STATUS ||= 204 }
  Error205 = ResetContent = Class.new(Rango::Successful) { STATUS ||= 205 }
  Error206 = PartialContent = Class.new(Rango::Successful) { STATUS ||= 206 }

  # redirection
  Redirection = Class.new(Rango::HttpError)
  Error300 = MultipleChoices = Class.new(Rango::Redirection) { STATUS ||= 300 }
  Error301 = MovedPermanently = Class.new(Rango::Redirection) { STATUS ||= 301 }
  Error302 = MovedTemporarily = Class.new(Rango::Redirection) { STATUS ||= 302 }
  Error303 = SeeOther = Class.new(Rango::Redirection) { STATUS ||= 303 }
  Error304 = NotModified = Class.new(Rango::Redirection) { STATUS ||= 304 }
  Error305 = UseProxy = Class.new(Rango::Redirection) { STATUS ||= 305 }
  Error307 = TemporaryRedirect = Class.new(Rango::Redirection) { STATUS ||= 307 }

  # client error
  ClientError = Class.new(Rango::HttpError)
  Error400 = BadRequest = Class.new(Rango::ClientError) { STATUS ||= 400 }
  MultiPartParseError = Class.new(Rango::BadRequest)
  Error401 = Unauthorized = Class.new(Rango::ClientError) { STATUS ||= 401 }
  Error402 = PaymentRequired = Class.new(Rango::ClientError) { STATUS ||= 402 }
  Error403 = Forbidden = Class.new(Rango::ClientError) { STATUS ||= 403 }
  Error404 = NotFound = Class.new(Rango::ClientError) { STATUS ||= 404 }
  ActionNotFound = Class.new(Rango::NotFound)
  TemplateNotFound = Class.new(Rango::NotFound)
  LayoutNotFound = Class.new(Rango::NotFound)
  Error405 = MethodNotAllowed = Class.new(Rango::ClientError) { STATUS ||= 405 }
  Error406 = NotAcceptable = Class.new(Rango::ClientError) { STATUS ||= 406 }
  Error407 = ProxyAuthenticationRequired = Class.new(Rango::ClientError) { STATUS ||= 407 }
  Error408 = RequestTimeout = Class.new(Rango::ClientError) { STATUS ||= 408 }
  Error409 = Conflict = Class.new(Rango::ClientError) { STATUS ||= 409 }
  Error410 = Gone = Class.new(Rango::ClientError) { STATUS ||= 410 }
  Error411 = LengthRequired = Class.new(Rango::ClientError) { STATUS ||= 411 }
  Error412 = PreconditionFailed = Class.new(Rango::ClientError) { STATUS ||= 412 }
  Error413 = RequestEntityTooLarge = Class.new(Rango::ClientError) { STATUS ||= 413 }
  Error414 = RequestURITooLarge = Class.new(Rango::ClientError) { STATUS ||= 414 }
  Error415 = UnsupportedMediaType = Class.new(Rango::ClientError) { STATUS ||= 415 }
  Error416 = RequestRangeNotSatisfiable = Class.new(Rango::ClientError) { STATUS ||= 416 }
  Error417 = ExpectationFailed = Class.new(Rango::ClientError) { STATUS ||= 417 }

  # server error
  ServerError = Class.new(Rango::HttpError)
  Error500 = InternalServerError = Class.new(Rango::ServerError) { STATUS ||= 500 }
  Error501 = NotImplemented = Class.new(Rango::ServerError) { STATUS ||= 501 }
  Error502 = BadGateway = Class.new(Rango::ServerError) { STATUS ||= 502 }
  Error503 = ServiceUnavailable = Class.new(Rango::ServerError) { STATUS ||= 503 }
  Error504 = GatewayTimeout = Class.new(Rango::ServerError) { STATUS ||= 504 }
  Error505 = HTTPVersionNotSupported = Class.new(Rango::ServerError) { STATUS ||= 505 }
end
